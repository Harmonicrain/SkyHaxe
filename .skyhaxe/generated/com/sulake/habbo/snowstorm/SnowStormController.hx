package com.sulake.habbo.snowstorm
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.communication.messages.incoming.room.session.RoomReadyMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.shockwavesnowstorm.*;
    import com.sulake.habbo.communication.messages.outgoing.shockwavesnowstorm.*;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.ui.IRoomUI;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.tickets.HotelTicketDialog;
    import com.sulake.habbo.communication.messages.outgoing.games.RequestLeaderboardMessageComposer;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    /**
     * Owns the original Shockwave SnowStorm lounge protocol and its authoritative client mirror.
     * The later AIR SnowWar component is deliberately not referenced here.
     */
     final class SnowStormController
    {
        static inline final LOBBY_MODEL= "snowwar_lobby_1";
        static inline final LOUNGE_INTERVAL_MS= 1000;
        static final RECOVERY_DELAYS:Array<ASAny> = [1000, 2000, 4000, 8000];
        static inline final SCREEN_LOBBY= "lobby";
        static inline final SCREEN_CREATE= "create";
        static inline final SCREEN_INFO= "info";
        static inline final SCREEN_ARENA= "arena";
        static inline final SCREEN_SCORES= "scores";

        var _communication:IHabboCommunicationManager;
        var _session:ISessionDataManager;
        var _localization:IHabboLocalizationManager;
        var _assets:SnowStormAssets;
        var _view:SnowStormView;
        var _ticketDialog:HotelTicketDialog;
        var _model:SnowStormModel = new SnowStormModel();
        var _events:Array<ASAny> = [];
        var _instances:Array<ASAny> = [];
        var _join:ASObject;
        var _selectedInstanceId:Int = -1;
        var _ticketCost:Int = 0;
        var _ticketBalance:Int = 0;
        var _skillLevel:Int = 1;
        var _rankedPoints:Int = 0;
        var _pendingCreate:Bool = false;
        var _openPending:Bool = false;
        var _inLobbyRoom:Bool = false;
        var _screen:String = SCREEN_LOBBY;
        var _historicalResult:ASObject;
        var _showingFinalScores:Bool = false;
        var _lastLoungeRequest:Int = -100000;
        var _clientActionSequence:Int = 0;
        var _recoveryAttempt:Int = 0;
        var _pendingRecoveryReason:Int = 0;
        var _checksumRecoverySnapshots:Int = 0;
        var _lastFullRequestAt:Int = -100000;
        var _soundAmmo:Int = -1;
        var _recoveryTimer:Timer;
        var _disposed:Bool = false;
        var _assetBaseUrl:String;

        public function new(communication:IHabboCommunicationManager,
                                            windows:IHabboWindowManager,
                                            session:ISessionDataManager,
                                            roomUI:IRoomUI,
                                            localization:IHabboLocalizationManager,
                                            assetBaseUrl:String,
                                            componentAssets:IAssetLibrary,
                                            ticketDialog:HotelTicketDialog,
                                            roomEngine:IRoomEngine,
                                            avatars:IAvatarRenderManager)
        {
            this._communication = communication;
            this._session = session;
            this._localization = localization;
            this._ticketDialog = ticketDialog;
            this._assetBaseUrl = assetBaseUrl;
            this._assets = new SnowStormAssets();
            this._assets.addEventListener(SnowStormAssets.READY, (this.onAssetsReady : ASAny));
            this._assets.addEventListener(SnowStormAssets.ERROR, (this.onAssetsError : ASAny));
            this._view = new SnowStormView(windows, componentAssets, this._assets, session,
                roomUI, localization, ticketDialog == null ? null : ticketDialog.open,
                roomEngine, avatars);
            if (this._ticketDialog != null)
            {
                this.applyTicketBalance(this._ticketDialog.balance);
                this._ticketDialog.addEventListener(Event.CHANGE, (this.onTicketBalanceChanged : ASAny));
            }
            this._model.playbackEventHandler = this.playSubturnSounds;
            this._view.setEventHandler(this.onViewEvent);
            this.registerMessages();
        }

        public function open()
        {
            if (this._disposed || this._view == null) return;
            if (!this.ensureAssetsLoaded())
            {
                this._openPending = true;
                return;
            }
            this._openPending = false;
            if (this._model.instanceId > 0 && this._model.map != null)
            {
                this.requestFull(3);
                return;
            }
            this.showLobby();
            this.requestLounge();
        }

        public function dispose()
        {
var event:IMessageEvent  = null;            if (this._disposed) return;
            this._disposed = true;
            if (this._ticketDialog != null)
                this._ticketDialog.removeEventListener(Event.CHANGE, (this.onTicketBalanceChanged : ASAny));
            this.cancelRecovery();
            this._model.playbackEventHandler = null;
            if (this._communication != null)
{                final _iter_ = this._events; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{event = _tmp_;
                    this._communication.removeHabboConnectionMessageEvent(event);
}};
            this._events = [];
            if (this._view != null) this._view.dispose();
            if (this._assets != null)
            {
                this._assets.removeEventListener(SnowStormAssets.READY, (this.onAssetsReady : ASAny));
                this._assets.removeEventListener(SnowStormAssets.ERROR, (this.onAssetsError : ASAny));
                this._assets.dispose();
            }
            this._view = null; this._assets = null; this._communication = null;
            this._session = null; this._localization = null; this._ticketDialog = null; this._join = null;
            this._instances = [];
        }

        function registerMessages()
        {
            this.add(new SnowStormLoungeInfoEvent(this.onMessage));
            this.add(new SnowStormInstanceListEvent(this.onMessage));
            this.add(new SnowStormGameInstanceEvent(this.onMessage));
            this.add(new SnowStormInstanceRemovedEvent(this.onMessage));
            this.add(new SnowStormJoinParametersEvent(this.onMessage));
            this.add(new SnowStormOperationFailedEvent(this.onMessage));
            this.add(new SnowStormGameLocationEvent(this.onMessage));
            this.add(new SnowStormGameResetEvent(this.onMessage));
            this.add(new SnowStormGameStartEvent(this.onMessage));
            this.add(new ShockwaveSnowStormFullGameStatusEvent(this.onMessage));
            this.add(new ShockwaveSnowStormGameStatusEvent(this.onMessage));
            this.add(new SnowStormGameEndEvent(this.onMessage));
            this.add(new SnowStormPlayerRemovedEvent(this.onMessage));
            this.add(new SnowStormSpectatorCountEvent(this.onMessage));
            this.add(new SnowStormFinishedGameEvent(this.onMessage));
            this.add(new SnowStormSkillLevelChangedEvent(this.onMessage));
            this.add(new SnowStormIdleWarningEvent(this.onMessage));
            this.add(new RoomReadyMessageEvent(this.onRoomReady));
        }

        function add(event:IMessageEvent)
        { this._events.push(this._communication.addHabboConnectionMessageEvent(event)); }

        function onMessage(event:IMessageEvent)
        {
var inserted = false, soundPlayer:ASObject  = null;            var parser= cast(event, SnowStormMessageEvent).getParser();
            if (parser == null) return;
            var data:ASObject = parser.data;
            switch (parser.header)
            {
                case SnowStormProtocol.LOUNGE_INFO:
                    this._ticketCost = ASCompat.toInt(data.ticketCost);
                    this._skillLevel = ASCompat.toInt(data.skillLevel);
                    this._rankedPoints = ASCompat.toInt(data.rankedPoints);
                    this.applyTicketBalance(ASCompat.toInt(data.ticketBalance));
                    if (this._ticketDialog != null) this._ticketDialog.setBalance(this._ticketBalance);
                    if (this._screen == SCREEN_LOBBY) this.showLobby();
                    
                case SnowStormProtocol.INSTANCE_LIST:
                    this._instances = data.instances == null ? [] : data.instances;
                    if (this._screen == SCREEN_LOBBY) this.showLobby();
                    
                case SnowStormProtocol.GAME_INSTANCE:
inserted= this.upsertInstance(data.instance);
                    if (inserted) this._view.resetLobbyPage();
                    if (this._pendingCreate && data.instance != null &&
                        ASCompat.toInt(data.instance.ownerUserId) == this.localUserId())
                    {
                        this._pendingCreate = false;
                        this._selectedInstanceId = ASCompat.toInt(data.instance.id);
                        this.send(new SnowStormInitiateJoinComposer(this._selectedInstanceId));
                    }
                    else if (this._screen == SCREEN_LOBBY) this.showLobby();
                    else if (this._screen == SCREEN_INFO && ASCompat.toInt(data.instance.id) == this._selectedInstanceId)
                        this.showGameInfo();
                    
                case SnowStormProtocol.INSTANCE_REMOVED:
                    this.removeInstance(ASCompat.toInt(data.rowKind), ASCompat.toInt(data.id));
                    if (ASCompat.toInt(data.rowKind) == 0 && ASCompat.toInt(data.id) == this._selectedInstanceId)
                    {
                        this.returnToLounge();
                    }
                    else if (this._screen == SCREEN_LOBBY) this.showLobby();
                    
                case SnowStormProtocol.JOIN_PARAMETERS:
                    this._join = data;
                    this._selectedInstanceId = ASCompat.toInt(data.instanceId);
                    this.showGameInfo();
                    
                case SnowStormProtocol.OPERATION_FAILED:
                    this._pendingCreate = false;
                    if (ASCompat.toInt(data.reason) == 7 && this.ticketOperation(ASCompat.toInt(data.operation)))
                        this._view.openTickets();
                    else
                        this._view.showError(this.failureText(ASCompat.toInt(data.reason)));
                    
                case SnowStormProtocol.GAME_LOCATION:
                    if (!this._model.applyLocation(data))
                    {
                        this._view.showError(this.failureText(13));
                    }
 else {                    this._selectedInstanceId = ASCompat.toInt(data.instanceId);
                    this._clientActionSequence = 0;
                    this._recoveryAttempt = 0;
                    this._pendingRecoveryReason = 0;
                    this._checksumRecoverySnapshots = 0;
                    this.requestFull(0, true);
                    
}                case SnowStormProtocol.GAME_START:
                    if (this.isCurrent(data) && this._model.applyStart(data))
                    {
                        this._screen = SCREEN_ARENA;
                        this._view.showArena(this._model);
                        this.requestFull(3);
                    }
                    
                case SnowStormProtocol.FULL_GAME_STATUS:
                    if (!this.isCurrent(data)) {} else {                    if (this._model.applyFullStatus(data, this.onRecoveryRequired))
                    {
                        this.cancelRecovery();
                        if (this._pendingRecoveryReason == 2) this._checksumRecoverySnapshots++;
                        else
                        {
                            this._recoveryAttempt = 0;
                            this._checksumRecoverySnapshots = 0;
                        }
                        this._pendingRecoveryReason = 0;
                        this._screen = SCREEN_ARENA;
soundPlayer= this._model.localPlayer();
                        this._soundAmmo = soundPlayer == null ? -1 : ASCompat.toInt(soundPlayer.snowballs);
                        this._view.showArena(this._model);
                    }
                    
};
                case SnowStormProtocol.GAME_STATUS:
                    if (this.isCurrent(data) && this._model.applyStatus(data, this.onRecoveryRequired))
                    {
                        this._recoveryAttempt = 0;
                        this._pendingRecoveryReason = 0;
                        this._checksumRecoverySnapshots = 0;
                        this._view.updateArena(this._model);
                    }
                    
                case SnowStormProtocol.GAME_END:
                    if (this.isCurrent(data) && this._model.applyEnd(data))
                    {
                        this._showingFinalScores = true;
                        this._screen = SCREEN_SCORES;
                        this._view.showFinalScores(data, this._model);
                    }
                    
                case SnowStormProtocol.GAME_RESET:
                    if (this.isCurrent(data))
                    {
                        this._model.applyReset(data);
                        if (!this._showingFinalScores)
                            this.send(new SnowStormInitiateJoinComposer(this._model.instanceId));
                    }
                    
                case SnowStormProtocol.PLAYER_REMOVED:
                    if (!this.isCurrent(data)) {} else {                    this.returnToLounge();
                    this._view.showError(this.removalText(ASCompat.toInt(data.reason)));
                    
};
                case SnowStormProtocol.SPECTATOR_COUNT:
                    if (this.isCurrent(data)) this._model.spectatorCount = ASCompat.toInt(data.spectatorCount);
                    
                case SnowStormProtocol.FINISHED_GAME:
                    this._historicalResult = data;
                    this._view.showHistoricalScores(data);
                    
                case SnowStormProtocol.SKILL_LEVEL_CHANGED:
                    this._skillLevel = ASCompat.toInt(data.skillLevel);
                    this._rankedPoints = ASCompat.toInt(data.rankedPoints);
                    
                case SnowStormProtocol.IDLE_WARNING:
                    if (this.isCurrent(data)) this._view.showError(
                        ASCompat.stringReplace(this.text("sw_error_idle_warning")
, "%seconds%", ASCompat.toString(data.secondsRemaining)));
                    
            }
        }

        function onTicketBalanceChanged(event:Event)
        {
            if (this._ticketDialog != null) this.applyTicketBalance(this._ticketDialog.balance);
        }

        function applyTicketBalance(value:Int)
        {
            this._ticketBalance = value;
            if (this._view != null) this._view.setTicketBalance(value);
        }

        function onRoomReady(event:IMessageEvent)
        {
            var parser= cast(event, RoomReadyMessageEvent).getParser();
            var inLobby= parser != null && parser.roomType == LOBBY_MODEL;
            if (inLobby == this._inLobbyRoom && !inLobby) return;
            this._inLobbyRoom = inLobby;
            if (inLobby)
            {
                this.open();
                return;
            }
            if (this._model.instanceId > 0)
                this.send(new SnowStormLeaveComposer(this._model.instanceId));
            this._openPending = false;
            this.resetMembership();
            if (this._view != null) this._view.hide();
        }

        function onViewEvent(event:SnowStormViewEvent)
        {
            if (event == null) return;
            var data:ASObject = event.data;
            switch (event.type)
            {
                case SnowStormViewEvent.REFRESH:
                    this.requestLounge(); 
                case SnowStormViewEvent.REDRAW:
                    if (data != null && data.error != null) this._view.showError(ASCompat.toString(data.error));
                    if (this._historicalResult != null)
                    {
                        this._historicalResult = null;
                        this._view.closeHistoricalScores();
                    }
                    this.redraw(); 
                case SnowStormViewEvent.SHOW_CREATE:
                    this._screen = SCREEN_CREATE;
                    this._view.showCreate(this._ticketCost);
                    
                case SnowStormViewEvent.CREATE:
                    this._pendingCreate = true;
                    this.send(new SnowStormSetGameParametersComposer(ASCompat.toString(data.name), ASCompat.toInt(data.mapId),
                        ASCompat.toInt(data.lengthChoice), ASCompat.toInt(data.teamCount), ASCompat.toInt(data.selectedTeam)));
                    
                case SnowStormViewEvent.JOIN:
                    this._selectedInstanceId = ASCompat.toInt(data.instanceId);
                    if (this._ticketBalance < this._ticketCost) this._view.openTickets();
                    else this.send(new SnowStormInitiateJoinComposer(this._selectedInstanceId));
                    
                case SnowStormViewEvent.JOIN_TEAM:
                    if (this._ticketBalance < this._ticketCost) this._view.openTickets();
                    else this.send(new SnowStormSetJoinParametersComposer(ASCompat.toInt(data.instanceId), ASCompat.toInt(data.teamId)));
                    
                case SnowStormViewEvent.WATCH:
                    this._selectedInstanceId = ASCompat.toInt(data.instanceId);
                    this.send(new SnowStormWatchComposer(this._selectedInstanceId)); 
                case SnowStormViewEvent.START:
                    this.send(new SnowStormStartComposer(ASCompat.toInt(data.instanceId))); 
                case SnowStormViewEvent.KICK:
                    this.send(new SnowStormKickComposer(ASCompat.toInt(data.instanceId), ASCompat.toInt(data.userId))); 
                case SnowStormViewEvent.ADD_BOT:
                    this.send(new SnowStormAddBotComposer(ASCompat.toInt(data.instanceId), ASCompat.toInt(data.teamId))); 
                case SnowStormViewEvent.REMOVE_BOT:
                    this.send(new SnowStormRemoveBotComposer(ASCompat.toInt(data.instanceId), ASCompat.toInt(data.userId))); 
                case SnowStormViewEvent.DELETE_GAME:
                    this.send(new SnowStormDeleteComposer(ASCompat.toInt(data.instanceId))); 
                case SnowStormViewEvent.LEAVE:
                    if (data != null && data.instanceId != null)
                        this.send(new SnowStormLeaveComposer(ASCompat.toInt(data.instanceId)));
                    else if (this._model.instanceId > 0)
                        this.send(new SnowStormLeaveComposer(this._model.instanceId));
                    this.returnToLounge(); 
                case SnowStormViewEvent.FINISHED_SCORES:
                    this.send(new SnowStormRequestFinishedGameComposer(ASCompat.toInt(data.resultId))); 
                case SnowStormViewEvent.REJOIN:
                    this._showingFinalScores = false;
                    if (this._model.instanceId > 0)
                        this.send(new SnowStormInitiateJoinComposer(this._model.instanceId));
                    else this.showLobby();
                    
                case SnowStormViewEvent.HIGH_SCORES:
                    if (this._communication != null && this._communication.connection != null)
                        this._communication.connection.send(new RequestLeaderboardMessageComposer(0, "WEEKLY", 0, 10));
                    
                case SnowStormViewEvent.GAME_RULES:
                    this._view.showRules(); 
                case SnowStormViewEvent.WALK:
                    this.sendAction(0, [ASCompat.toInt(data.x), ASCompat.toInt(data.y)]); 
                case SnowStormViewEvent.THROW_PLAYER:
                    this.sendAction(1, [ASCompat.toInt(data.objectId), ASCompat.toInt(data.trajectory)]); 
                case SnowStormViewEvent.THROW_LOCATION:
                    this.sendAction(2, [ASCompat.toInt(data.x), ASCompat.toInt(data.y), ASCompat.toInt(data.trajectory)]); 
                case SnowStormViewEvent.MAKE_SNOWBALL:
                    this.sendAction(3); 
                case SnowStormViewEvent.CANCEL_MAKE:
                    this.sendAction(4); 
            }
        }

        function redraw()
        {
            if (this._screen == SCREEN_CREATE) this._view.showCreate(this._ticketCost);
            else if (this._screen == SCREEN_INFO) this.showGameInfo();
            else if (this._screen == SCREEN_SCORES && this._model.finalResult != null)
                this._view.showFinalScores(this._model.finalResult, this._model);
            else this.showLobby();
        }

        function showLobby()
        {
            this._screen = SCREEN_LOBBY;
            this._view.showLobby(this._instances, this._ticketCost, this._skillLevel);
        }

        function showGameInfo()
        {
            var instance:ASObject = this.findInstance(this._selectedInstanceId);
            if (instance == null || this._join == null) { this.showLobby(); return; }
            this._screen = SCREEN_INFO;
            this._view.showGameInfo(instance, this._join, this._ticketCost);
        }

        function requestLounge()
        {
            var now= flash.Lib.getTimer();
            if (now - this._lastLoungeRequest < LOUNGE_INTERVAL_MS) return;
            this._lastLoungeRequest = now;
            this.send(new SnowStormGetLoungeComposer());
        }

        function onRecoveryRequired(reason:Int)
        {
            if (reason == 2 && this._checksumRecoverySnapshots >= RECOVERY_DELAYS.length)
            {
                this.failRecovery();
                return;
            }
            this.requestFull(reason);
        }

        function requestFull(reason:Int, immediate:Bool=false)
        {
            if (this._model.instanceId <= 0) return;
            if (reason > 0) this._pendingRecoveryReason = reason;
            if (reason == 0 || immediate)
            {
                this.sendFull(reason);
                return;
            }
            if (this._recoveryTimer != null) return;
            if (this._recoveryAttempt >= RECOVERY_DELAYS.length)
            {
                this.failRecovery();
                return;
            }
            var delay= ASCompat.toInt(RECOVERY_DELAYS[this._recoveryAttempt++]);
            this._recoveryTimer = new Timer(delay, 1);
            this._recoveryTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onRecoveryTimer : ASAny));
            this._recoveryTimer.start();
        }

        function onRecoveryTimer(event:TimerEvent)
        {
            this.cancelRecovery(false);
            this.sendFull(2);
        }

        function sendFull(reason:Int)
        {
            var now= flash.Lib.getTimer();
            var elapsed= now - this._lastFullRequestAt;
            if (elapsed < 1000 && reason != 0)
            {
                this.requestFull(reason);
                return;
            }
            this._lastFullRequestAt = now;
            this.send(new SnowStormRequestFullStatusComposer(this._model.instanceId,
                Std.int(Math.max(0, this._model.sequence)), reason));
        }

        function failRecovery()
        {
            if (this._model.instanceId <= 0) return;
            var instanceId= this._model.instanceId;
            this._view.showError(this.text("sw_error_sync_failed"));
            this.send(new SnowStormLeaveComposer(instanceId));
            this.returnToLounge();
        }

        function cancelRecovery(disposeTimer:Bool=true)
        {
            if (this._recoveryTimer == null) return;
            this._recoveryTimer.stop();
            this._recoveryTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onRecoveryTimer : ASAny));
            if (disposeTimer) this._recoveryTimer.reset();
            this._recoveryTimer = null;
        }

        function sendAction(subtype:Int, fields:Array<ASAny>=null)
        {
            if (this._model.instanceId <= 0 || this._model.spectator) return;
            this._clientActionSequence++;
            this.send(new SnowStormGameEventComposer(this._model.instanceId,
                this._clientActionSequence, subtype, fields));
        }

        /** Plays only events from an accepted authoritative delta, so retries/stale packets stay silent. */
        function playSubturnSounds(events:Array<ASAny>)
        {
var event:ASObject  = null, hit = 0;            if (this._assets == null || events == null) return;
            if (checkNullIteratee(events)) for (_tmp_ in events)
            {
event = _tmp_;
                if (event == null) continue;
                switch (ASCompat.toInt(event.type))
                {
                    case SnowStormProtocol.EVENT_SNOWBALL_MISS:
                        this._assets.play("hh_game_snowwar_LS_miss");
                        
                    case SnowStormProtocol.EVENT_AVATAR_THROW:
                        this._assets.play("hh_game_snowwar_LS_throw");
                        
                    case SnowStormProtocol.EVENT_HIT:
                        if (this._view != null) this._view.showHit(ASCompat.toInt(event.impactWorldX),
                            ASCompat.toInt(event.impactWorldY), ASCompat.toInt(event.impactWorldZ));
hit= Std.int(Math.abs(ASCompat.toInt(event.direction)) % 3 + 1);
                        this._assets.play("hh_game_snowwar_LS_hit_" + Std.string(hit));
                        
                        
                    case SnowStormProtocol.EVENT_STUN:
hit= Std.int(Math.abs(ASCompat.toInt(event.direction)) % 3 + 1);
                        this._assets.play("hh_game_snowwar_LS_hit_" + Std.string(hit));
                        
                        
                    case SnowStormProtocol.EVENT_SNOWBALL_COUNT:
                        if (ASCompat.toInt(event.objectId) == this._model.playerObjectId)
                        {
                            if (this._soundAmmo >= 0 && ASCompat.toInt(event.count) > this._soundAmmo)
                                this._assets.play("hh_game_snowwar_LS_getsnowball");
                            this._soundAmmo = ASCompat.toInt(event.count);
                        }
                        
                    case SnowStormProtocol.EVENT_MACHINE_TRANSFER:
                        if (ASCompat.toInt(event.playerId) == this._model.playerObjectId)
                        {
                            if (this._soundAmmo >= 0 && ASCompat.toInt(event.playerCount) > this._soundAmmo)
                                this._assets.play("hh_game_snowwar_LS_getsnowball");
                            this._soundAmmo = ASCompat.toInt(event.playerCount);
                        }
                        
                }
            }
        }

        function upsertInstance(value:ASObject):Bool
        {
var             index = 0;            if (value == null) return false;
            var key= this.rowKey(value);
            index= 0;while (index < this._instances.length)
            {
                if (this.rowKey(this._instances[index]) == key)
                { this._instances[index] = value; return false; }
index++;
            }
            // GAME_INSTANCE carries live rows. Instance ids are monotonic, so a newly
            // published game belongs at the head of the live section, matching the
            // server's canonical newest-first snapshot order.
            this._instances.unshift(value);
            return true;
        }

        function removeInstance(rowKind:Int, id:Int)
        {
var index = 0;            for (_tmp_ in (0...this._instances.length).reverse())
{index= _tmp_;
                if (ASCompat.toInt(this._instances[index].rowKind) == rowKind && ASCompat.toInt(this._instances[index].id) == id)
                    this._instances.splice(index, 1);
};
        }

        function findInstance(id:Int):ASObject
        {
var value:ASObject  = null;            final _iter_ = this._instances; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{value = _tmp_;
                if (ASCompat.toInt(value.rowKind) == 0 && ASCompat.toInt(value.id) == id) return value;
};
            return null;
        }

        function rowKey(value:ASObject):String
        { return Std.string(ASCompat.toInt(value.rowKind)) + ":" + Std.string(ASCompat.toInt(value.id)) + ":" + Std.string(ASCompat.toInt(value.resultId)); }

        function isCurrent(data:ASObject):Bool
        { return data != null && this._model.instanceId > 0 && ASCompat.toInt(data.instanceId) == this._model.instanceId; }

        function ticketOperation(operation:Int):Bool
        { return operation == 1 || operation == 3 || operation == 4 || operation == 8; }

        function resetMembership()
        {
            this.cancelRecovery();
            this._model.reset(); this._join = null; this._selectedInstanceId = -1;
            this._pendingCreate = false; this._showingFinalScores = false;
            this._clientActionSequence = 0; this._recoveryAttempt = 0;
            this._pendingRecoveryReason = 0; this._checksumRecoverySnapshots = 0;
            this._soundAmmo = -1;
            this._screen = SCREEN_LOBBY;
        }

        /**
         * A charged arena removes its participants from the server's lounge subscriber set while
         * play is active. Returning to the still-open physical lounge therefore has to request a
         * fresh lounge snapshot; merely redrawing the cached list leaves Create/Join unauthorized.
         */
        function returnToLounge()
        {
            this.resetMembership();
            if (this._inLobbyRoom) this.open();
            else if (this._view != null) this._view.hide();
        }

        function localUserId():Int
        { return this._session == null ? 0 : this._session.userId; }

        function failureText(reason:Int):String
        {
            if (reason < 0 || reason > 14) reason = 0;
            return this.text("sw_error_" + Std.string(reason));
        }

        function removalText(reason:Int):String
        {
            if (reason == 2)
                return this.text("sw_error_participant_left");
            return reason == 1
                ? this.text("sw_error_idle_removed")
                : this.text("sw_error_kicked");
        }

        function text(key:String):String
        {
            if (this._localization == null) return key;
            var value= this._localization.getLocalization(key);
            return value == null || value == "" ? key : value;
        }

        function onAssetsReady(event:Event)
        { if (this._inLobbyRoom || this._openPending) this.open(); }

        function ensureAssetsLoaded():Bool
        {
            if (this._assets == null || this._disposed) return false;
            if (this._assets.isReady) return true;
            this._assets.load(this._assetBaseUrl);
            return false;
        }


        function onAssetsError(event:Event)
        {
            this._openPending = false;
            if (this._view != null) this._view.showError(this.text("sw_error_assets"));
        }

        function send(composer:IMessageComposer)
        {
            if (this._communication != null && this._communication.connection != null)
                this._communication.connection.send(composer);
        }
    }
