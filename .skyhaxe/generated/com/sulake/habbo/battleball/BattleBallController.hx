package com.sulake.habbo.battleball
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.habbo.communication.messages.incoming.battleball.*;
    import com.sulake.habbo.communication.messages.outgoing.battleball.*;
    import com.sulake.habbo.communication.messages.incoming.room.session.RoomReadyMessageEvent;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.sound.IHabboSoundManager;
    import com.sulake.habbo.ui.IRoomUI;
    import com.sulake.habbo.tickets.HotelTicketDialog;
    import com.sulake.habbo.communication.messages.outgoing.games.RequestLeaderboardMessageComposer;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.events.Event;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;

    /** Coordinates original BattleBall networking, authoritative state, assets, sound and native UI. */
     final class BattleBallController
    {
        var _communication:IHabboCommunicationManager;
        var _session:ISessionDataManager;
        var _assets:BattleBallAssets;
        var _view:BattleBallView;
        var _model:BattleBallModel = new BattleBallModel();
        var _events:Array<ASAny> = [];
        var _instances:Array<ASAny> = [];
        var _ticketCost:Int = 0;
        var _ticketBalance:Int = 0;
        var _skillLevel:Int = 1;
        var _music:SoundChannel;
        var _pendingCreate:Bool = false;
        var _arena:BattleBallArena;
        var _roomUI:IRoomUI;
        var _soundManager:IHabboSoundManager;
        var _localization:IHabboLocalizationManager;
        var _ticketDialog:HotelTicketDialog;
        /** Final standings are modal: nothing replaces them until the player chooses. */
        var _showingFinalScores:Bool = false;
        var _historicalResult:ASObject;
        /** Redraws the arena between server updates so the clock counts down and avatars keep animating. */
        var _clock:Timer;
        /**
         * Room model that hosts the BattleBall lounge. RoomReady carries the model name the server sent,
         * so entering that room is what opens the UI; it no longer appears on login.
         */
        static inline final LOBBY_MODEL= "bb_lobby_1";
        var _inLobbyRoom:Bool = false;
        var _lastInstanceListRequest:Int = -100000;
        static inline final FULL_REQUEST_BACKOFF_MS= 1000;
        var _lastFullRequestAt:Int = -100000;
        var _lastFullRequestInstance:Int = -1;
        var _pendingFullRequestInstance:Int = -1;
        var _fullRequestTimer:Timer;
        var _countdownResyncAt:Int = 0;
        var _countdownSequence:Int = -1;

        public function new(communication:IHabboCommunicationManager, windows:IHabboWindowManager,
                                              session:ISessionDataManager, avatars:IAvatarRenderManager,
                                              roomEngine:IRoomEngine, roomUI:IRoomUI,
                                              soundManager:IHabboSoundManager,
                                              localization:IHabboLocalizationManager, assetBaseUrl:String,
                                              componentAssets:IAssetLibrary,
                                              ticketDialog:HotelTicketDialog)
        {
            this._communication = communication; this._session = session; this._roomUI = roomUI;
            this._soundManager = soundManager;
            this._localization = localization;
            this._ticketDialog = ticketDialog;
            this._arena = new BattleBallArena(roomEngine);
            this._assets = new BattleBallAssets();
            this._assets.addEventListener(BattleBallAssets.READY, (this.onAssetsReady : ASAny));
            this._assets.addEventListener(BattleBallAssets.ERROR, (this.onAssetsError : ASAny));
            this._assets.load(assetBaseUrl);
            this._view = new BattleBallView(windows, this._assets, componentAssets, avatars, session,
                this._arena, roomUI, localization, ticketDialog == null ? null : ticketDialog.open);
            if (this._ticketDialog != null)
            {
                this._ticketBalance = this._ticketDialog.balance;
                this._view.setTicketBalance(this._ticketBalance);
                this._ticketDialog.addEventListener(Event.CHANGE, (this.onTicketBalanceChanged : ASAny));
            }
            this._view.setEventHandler(this.onViewEvent);
            this.registerMessages();
        }

        public function open()
        {
            if (this._model.instanceId > 0)
            {
                this._view.open();
                // Same reasoning as REJOIN below: we are still a member, so ask for the current state
                // rather than for a rejoin the server can never grant.
                this.requestFull(this._model.instanceId);
                return;
            }
            // Raise the sidebar straight away rather than waiting on the round trip, otherwise entering
            // the lounge leaves the left of the room empty until the list arrives.
            this._view.showLobby(this._instances, this._ticketCost, this._skillLevel);
            this.bindViewEvents();
            this.requestInstanceList();
        }

        /**
         * Packet 7500 is rate limited server-side and several paths can open the lounge at once --
         * leaving a game and re-entering the room both do, within the same few milliseconds. Collapse
         * those into one request; the server pushes list changes to lounge subscribers anyway.
         */
        function requestInstanceList()
        {
            var now= flash.Lib.getTimer();
            if (now - this._lastInstanceListRequest < 1000) return;
            this._lastInstanceListRequest = now;
            this.send(new BattleBallGetInstanceListComposer());
        }

        public function dispose()
        {
var event:IMessageEvent  = null;            if (this._ticketDialog != null)
                this._ticketDialog.removeEventListener(Event.CHANGE, (this.onTicketBalanceChanged : ASAny));
            final _iter_ = this._events; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) {event = _tmp_;
this._communication.removeHabboConnectionMessageEvent(event);
};
            this._events = [];
            if (this._music != null) { this._music.stop(); this._music = null; }
            if (this._view != null) { this._view.dispose(); this._view = null; }
            if (this._assets != null) { this._assets.dispose(); this._assets = null; }
            this.leaveArena();
            if (this._arena != null) { this._arena.dispose(); this._arena = null; }
            this._communication = null; this._session = null; this._roomUI = null; this._soundManager = null;
            this._localization = null; this._ticketDialog = null;
        }

        function registerMessages()
        {
            this.add(new BattleBallLoungeInfoEvent(this.onMessage));
            this.add(new BattleBallInstanceListEvent(this.onMessage));
            this.add(new BattleBallGameInstanceEvent(this.onMessage));
            this.add(new BattleBallInstanceNotAvailableEvent(this.onMessage));
            this.add(new BattleBallCreateFailedEvent(this.onMessage));
            this.add(new BattleBallGameDeletedEvent(this.onMessage));
            this.add(new BattleBallJoinParametersEvent(this.onMessage));
            this.add(new BattleBallJoinFailedEvent(this.onMessage));
            this.add(new BattleBallWatchFailedEvent(this.onMessage));
            this.add(new BattleBallGameLocationEvent(this.onMessage));
            this.add(new BattleBallStartFailedEvent(this.onMessage));
            this.add(new BattleBallFullGameStatusEvent(this.onMessage));
            this.add(new BattleBallGameStatusEvent(this.onMessage));
            this.add(new BattleBallPlayerRemovedEvent(this.onMessage));
            this.add(new BattleBallGameStartEvent(this.onMessage));
            this.add(new BattleBallGameEndEvent(this.onMessage));
            this.add(new BattleBallSpectatorCountEvent(this.onMessage));
            this.add(new BattleBallIdleWarningEvent(this.onMessage));
            this.add(new BattleBallSkillLevelChangedEvent(this.onMessage));
            this._events.push(this._communication.addHabboConnectionMessageEvent(
                new RoomReadyMessageEvent(this.onRoomReady)));
        }

        function add(event:IMessageEvent)
        {
            this._events.push(this._communication.addHabboConnectionMessageEvent(event));
        }

        function onMessage(event:IMessageEvent)
        {
var current:ASObject  = null, scoredPlayer:ASObject  = null;            var parser= cast(event, BattleBallMessageEvent).getParser();
            var data:ASObject = parser.data;
            switch (parser.header)
            {
                case BattleBallProtocol.LOUNGE_INFO:
                    this._ticketCost = ASCompat.toInt(data.ticketCost); this._skillLevel = ASCompat.toInt(data.skillLevel);
                    this.applyTicketBalance(ASCompat.toInt(data.ticketBalance));
                    if (this._ticketDialog != null) this._ticketDialog.setBalance(this._ticketBalance);
                    
                case BattleBallProtocol.INSTANCE_LIST:
                    this._instances = data.instances;
                    if (this._historicalResult == null) this.showLobby();
                    
                case BattleBallProtocol.GAME_INSTANCE:
                    if (ASCompat.toInt(data.instance.instanceId) < 0)
                    {
                        this._historicalResult = data.instance;
                        this._showingFinalScores = true;
                        this.showHistoricalScores();
                    }
                    else
                    {
                        this.upsertInstance(data.instance);
                        if (this._model.instanceId < 0) this.showLobby();
                    }
                    
                case BattleBallProtocol.GAME_DELETED:
                    this.removeInstance(ASCompat.toInt(data.instanceId));
                    if (this._model.instanceId == data.instanceId)
                    {
                        // The game we were in is gone: drop everything and go back to the list.
                        this.stopMusic(); this.leaveArena();
                        this._showingFinalScores = false;
                        this._model.reset(); this.open();
                    }
                    else if (this._model.instanceId < 0)
                    {
                        // Not in a game, so we are either browsing the list or sitting on that game's
                        // team picker. Redraw: dropping the row is not enough on its own, and whoever
                        // was picking a team for the cancelled game has to be brought back.
                        this.showLobby();
                    }
                    
                case BattleBallProtocol.PLAYER_REMOVED:
                    if (!this.isCurrentInstance(data)) {} else {                    this.stopMusic(); this.leaveArena();
                    this._showingFinalScores = false;
                    this._model.reset(); this.open();
                    this._view.showError(this.removalText(ASCompat.toInt(data.reason)));
                    
};
                case BattleBallProtocol.JOIN_PARAMETERS:
                    this._view.showJoinTeams(ASCompat.toInt(data.instanceId), data.teams); 
                case BattleBallProtocol.GAME_LOCATION:
                    this.clearCountdownResync();
                    if (this._model.instanceId != data.instanceId) this.clearFullRequestState();
                    this._model.applyLocation(data);
current= this.findInstance(ASCompat.toInt(data.instanceId));
                    // A game we just created is ours even if its lobby summary has not arrived yet.
                    if (current != null) this._model.ownerUserId = ASCompat.toInt(current.ownerUserId);
                    else if (this._pendingCreate) this._model.ownerUserId = this._session.userId;
                    else this._model.ownerUserId = 0;
                    this._pendingCreate = false;
                    this.requestFull(this._model.instanceId); 
                case BattleBallProtocol.FULL_STATUS
                   | BattleBallProtocol.STATUS:
                    if (this._model.applyStatus(data, this.requestFull))
                    {
                        if (data.full) this.clearPendingFullRequest(ASCompat.toInt(data.instanceId));
                        if (this._countdownResyncAt > 0 && this._model.sequence > this._countdownSequence)
                            this._countdownResyncAt = 0;
                        this.handlePresentation(data.events); this.presentGame();
                    }
                    
                case BattleBallProtocol.GAME_START:
                    if (this._model.applyGameStart(data))
                    {
                        this.clearCountdownResync();
                        this.enterArena(); this._view.showArena(this._model);
                        this.playMusic();
                    }
                    
                case BattleBallProtocol.GAME_END:
                    // Every packet carries the instance it belongs to. Without this check a delayed end
                    // from a previous match overwrote the live scores, stopped the music and forced the
                    // standings up over a round still in progress.
                    if (!this.isCurrentInstance(data) || !this._model.applyGameEnd(data)) {} else {                    // The round is over. BB Gameover Class.ls opens the score window over the arena and
                    // only returns the player to the lounge when they press Stop playing (enterLounge)
                    // or the server resets the game -- so the arena stays up behind the standings.
                    // The end packet is the authoritative final result. Apply both maps before choosing
                    // Best Player; live object snapshots intentionally do not carry cumulative scores.
                    this._model.scores = data.scores;
                    final _iter_:ASObject = this._model.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
scoredPlayer = _tmp_;
                        if (scoredPlayer.type != 0) continue;
                        scoredPlayer.score = data.playerScores != null
                            && ASCompat.hasOwnProperty(data.playerScores, scoredPlayer.userId)                            ? ASCompat.toInt(data.playerScores[scoredPlayer.userId]) : 0;
                    }
                    this.stopMusic(); this.playResult(ASCompat.toInt(data.winningTeam));
                    this._showingFinalScores = true;
                    this.showFinalScores();
                    
};
                case BattleBallProtocol.SPECTATOR_COUNT:
                    if (!this.isCurrentInstance(data)) {} else {                    this._model.spectatorCount = Std.int(Math.max(0, ASCompat.toInt(data.spectatorCount)));
                    if (this._model.state == 0 && !this._showingFinalScores) this.presentGame();
                    
};
                case BattleBallProtocol.SKILL_LEVEL_CHANGED:
                    this._skillLevel = ASCompat.toInt(data.skillLevel); 
                case BattleBallProtocol.IDLE_WARNING:
                    this._view.showError(ASCompat.stringReplace(this.text("bb_error_idle_warning")
, "%seconds%", data.secondsRemaining)); 
                case BattleBallProtocol.JOIN_FAILED:
                    if (data.reason == 7) this._view.openTickets();
                    else this._view.showError(this.failureText(ASCompat.toInt(data.reason)));
                    
                case BattleBallProtocol.CREATE_FAILED
                   | BattleBallProtocol.INSTANCE_NOT_AVAILABLE
                   | BattleBallProtocol.WATCH_FAILED
                   | BattleBallProtocol.START_FAILED:
                    this._view.showError(this.failureText(ASCompat.toInt(data.reason))); 
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

        /**
         * Entering the lounge opens the UI and refreshes the instance list; entering anywhere else puts it
         * away. Re-requesting on every entry is what keeps the list current rather than showing whatever
         * was cached from a previous visit.
         */
        function onRoomReady(event:IMessageEvent)
        {
            var parser= cast(event, RoomReadyMessageEvent).getParser();
            var inLobby= parser != null && parser.roomType == LOBBY_MODEL;
            if (inLobby == this._inLobbyRoom && !inLobby) return;
            this._inLobbyRoom = inLobby;
            if (inLobby)
            {
                if (this._assets != null && this._assets.isReady) this.open();
                return;
            }
            this._showingFinalScores = false;
            // Tell the server before forgetting the match. Resetting the model locally without sending
            // Leave orphaned server membership: the player stayed seated in game.players() with no
            // instance id left to leave with, so every later create or join was refused as "already in
            // a game" until they relogged.
            if (this._model.instanceId > 0) this.send(new BattleBallLeaveComposer(this._model.instanceId));
            this.leaveArena();
            this._model.reset();
            if (this._view != null) this._view.hide();
        }

        /**
         * Whether a packet belongs to the match this client is actually in.
         *
         * Every BattleBall packet carries its instance id and the parser reads it, but the handlers
         * used to ignore it, so a delayed packet from a previous match mutated the current one.
         */
        function isCurrentInstance(data:ASObject):Bool
        {
            if (data == null) return false;
            if (this._model.instanceId <= 0) return false;
            return ASCompat.toInt(data.instanceId) == this._model.instanceId;
        }

        function onAssetsReady(event:Event)
        {
            // The lounge may already have been entered while the three libraries were still downloading.
            if (this._inLobbyRoom) this.open();
        }

        function onAssetsError(event:Event)
        {
            this._view.showError(this.text("bb_error_assets"));
        }

        /**
         * Chooses between the pre-game window and the arena. Shockwave kept a joined player in the game
         * info window until play actually began; showing the arena on every status update meant creating
         * or joining a game dropped the player straight onto the board with nothing started.
         */
        function presentGame()
        {
            // Final standings stay put until the player picks play-again or stop; status packets keep
            // arriving after the round ends and would otherwise pull the window away underneath them.
            if (this._showingFinalScores) return;
            if (this._model.instanceId < 0) { this.showLobby(); return; }
            if (this._model.state == 0)
            {
                this.leaveArena();
                this._view.showGameInfo(this._model, this.findInstance(this._model.instanceId), this._ticketCost);
                return;
            }
            this.enterArena();
            this._view.showArena(this._model);
        }

        /** Picks the best player by score across every team, for the window's own panel. */
        function showFinalScores()
        {
var object:ASObject  = null;            var best:ASObject = null;
            final _iter_:ASObject = this._model.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
object = _tmp_;
                if (object.type != 0) continue;
                if (best == null || ASCompat.toInt(object.score) > ASCompat.toInt(best.score)) best = object;
            }
            this._view.showFinalScores(this._model, this.findInstance(this._model.instanceId), this._ticketCost,
                best == null ? "" : ASCompat.toString(best.name), best == null ? 0 : ASCompat.toInt(best.score));
            this.bindViewEvents();
        }

        function showHistoricalScores()
        {
            if (this._historicalResult == null) { this.showLobby(); return; }
            this._view.showHistoricalScores(this._historicalResult, this._ticketCost);
            this.bindViewEvents();
        }

        function showLobby()
        {
            // A new game is broadcast to everyone watching the games list, so this runs on clients that
            // are nowhere near the lounge. Refresh their cached list, but only put the window on screen
            // for players actually standing in the lounge room.
            if (!this._inLobbyRoom) return;
            this.leaveArena();
            this._view.showLobby(this._instances, this._ticketCost, this._skillLevel);
            this.bindViewEvents();
        }

        function bindViewEvents()
        {
            this._view.setEventHandler(this.onViewEvent);
        }

        function onViewEvent(event:BattleBallViewEvent)
        {
            var data:ASObject = event.data;
            switch (event.type)
            {
                case BattleBallViewEvent.REFRESH:
                    this.requestInstanceList(); 
                case BattleBallViewEvent.HIGH_SCORES:
                    // Not send(): that helper is typed to the BattleBall composers. The server answers
                    // with the shared room-scoped leaderboard response.
                    if (this._communication != null && this._communication.connection != null)
                    {
                        this._communication.connection.send(new RequestLeaderboardMessageComposer(0, "WEEKLY", 0, 10));
                    }
                    
                case BattleBallViewEvent.GAME_RULES:
                    this._view.showRules();
                    
                case BattleBallViewEvent.REDRAW:
                    // Paging and the placeholder links only need the view rebuilt from the list we
                    // already hold; asking the server each time tripped its rate limit on 7500.
                    if (this._historicalResult != null) this.showHistoricalScores();
                    else if (this._showingFinalScores) this.showFinalScores();
                    else if (this._model.instanceId > 0) this.presentGame();
                    else this.showLobby();
                    
                case BattleBallViewEvent.CREATE:
                    this._pendingCreate = true;
                    this.send(new BattleBallSetGameParametersComposer(data.name, ASCompat.toInt(data.mapId), ASCompat.toInt(data.roundSeconds), ASCompat.toInt(data.teamCount),
                        ASCompat.toInt(data.teamCapacity), ASCompat.toInt(data.selectedTeam), data.privateGame, data.powers)); 
                case BattleBallViewEvent.JOIN:
                    this.send(new BattleBallInitiateJoinComposer(ASCompat.toInt(data.instanceId))); 
                case BattleBallViewEvent.JOIN_TEAM:
                    this.send(new BattleBallSetJoinParametersComposer(ASCompat.toInt(data.instanceId), ASCompat.toInt(data.teamId))); 
                case BattleBallViewEvent.WATCH:
                    this.send(new BattleBallWatchComposer(ASCompat.toInt(data.instanceId))); 
                case BattleBallViewEvent.START:
                    if (this._model.instanceId > 0) this.send(new BattleBallStartComposer(this._model.instanceId)); 
                case BattleBallViewEvent.REJOIN:
                    // "Join next game, too" -- the player never left. A finished round returns the game
                    // to its lobby with everyone still seated, so this is not a rejoin: it dismisses the
                    // standings and resyncs the instance that is already ours.
                    //
                    // It used to send Rejoin, which only ever succeeds for a player the server is
                    // holding open after a disconnect. Nothing marks players disconnected -- they are
                    // removed immediately -- so that path always answered NOT_A_PLAYER and the button
                    // did nothing at all.
                    this._showingFinalScores = false;
                    if (this._model.instanceId > 0) this.requestFull(this._model.instanceId);
                    else this.open();
                    
                case BattleBallViewEvent.KICK:
                    if (this._model.instanceId > 0)
                    {
                        if (ASCompat.toInt(data.userId) < 0)
                            this.send(new BattleBallRemoveBotComposer(this._model.instanceId, ASCompat.toInt(data.userId)));
                        else
                            this.send(new BattleBallKickComposer(this._model.instanceId, ASCompat.toInt(data.userId)));
                    }
                    
                case BattleBallViewEvent.ADD_BOT:
                    if (this._model.instanceId > 0)
                        this.send(new BattleBallAddBotComposer(this._model.instanceId, ASCompat.toInt(data.teamId)));
                    
                case BattleBallViewEvent.LEAVE:
                    if (this._model.instanceId > 0) this.send(new BattleBallLeaveComposer(this._model.instanceId));
                    this._showingFinalScores = false;
                    this._historicalResult = null;
                    this._view.closeHistoricalScores();
                    this.stopMusic(); this.leaveArena(); this._model.reset(); this.open(); 
                case BattleBallViewEvent.CLOSE:
                    if (this._model.instanceId > 0) this.send(new BattleBallLeaveComposer(this._model.instanceId));
                    this._showingFinalScores = false;
                    this._historicalResult = null;
                    this._view.closeHistoricalScores();
                    // Reopen straight away, exactly as LEAVE does. A player got the lounge back anyway
                    // because their departure broadcasts a lobby update, but a spectator leaving is
                    // silent -- the server tells nobody -- so the sidebar stayed missing until the
                    // round ended and a broadcast happened to arrive.
                    this.stopMusic(); this.leaveArena(); this._model.reset(); this.open(); 
                case BattleBallViewEvent.DELETE_GAME:
                    if (this._model.instanceId > 0) this.send(new BattleBallDeleteComposer(this._model.instanceId)); 
                case BattleBallViewEvent.MOVE:
                    if (this._model.instanceId > 0) this.send(BattleBallGameEventComposer.move(this._model.instanceId, ASCompat.toInt(data.x), ASCompat.toInt(data.y))); 
                case BattleBallViewEvent.ACTIVATE:
                    if (this._model.instanceId > 0) this.send(BattleBallGameEventComposer.activate(this._model.instanceId, ASCompat.toInt(data.powerObjectId))); 
            }
        }

        /** The arena stands in for the room, so the room underneath is hidden while a match is on screen. */
        function enterArena()
        {
            // The room stays visible and live behind the arena. It used to be hidden because the server
            // pulled the player out of it and what remained was stale; they now stay in the room, so
            // there is nothing to cover -- the arena is a window over a room they are still standing in.
            if (this._clock == null)
            {
                this._clock = new Timer(250);
                this._clock.addEventListener(TimerEvent.TIMER, (this.onClockTick : ASAny));
            }
            if (!this._clock.running) this._clock.start();
        }

        function leaveArena()
        {
            this.clearCountdownResync();
            this.clearFullRequestState();
            if (this._clock != null)
            {
                this._clock.stop();
                this._clock.removeEventListener(TimerEvent.TIMER, (this.onClockTick : ASAny));
                this._clock = null;
            }
            // Drop the arena room itself. Players and spectators both leave through here, and keeping
            // the room alive is what made avatars slide from their old positions on the way back in.
            if (this._arena != null) this._arena.release();
            // Nothing else to restore: the room was never hidden.
        }

        function clearCountdownResync()
        {
            this._countdownResyncAt = 0;
            this._countdownSequence = -1;
        }

        function onClockTick(event:TimerEvent)
        {
            // BattleBall music is a raw cast Sound rather than a Trax song, so keep its channel in
            // step with the client's Jukebox slider while it is playing.
            this.syncMusicVolume();
            if (this._view == null || this._model == null || this._model.instanceId < 0) return;
            // A game that has not started yet belongs in the game info window, and the room must stay
            // visible behind it. Only take the room over once play has actually begun.
            if (this._model.state == 0) return;
            // The standings own the screen once the round ends; ticking over them would replace them.
            if (this._showingFinalScores) return;
            // The room desktop re-shows its own canvas after we hide it, so hiding once on entry does not
            // hold. Re-assert it each tick while the arena is up rather than trying to find every path
            // that turns it back on.
            this.enterArena();
            if (this._model.advanceClock())
            {
                this._countdownSequence = this._model.sequence;
                this._countdownResyncAt = flash.Lib.getTimer() + 1500;
            }
            else if (this._countdownResyncAt > 0 && flash.Lib.getTimer() >= this._countdownResyncAt)
            {
                this._countdownResyncAt = 0;
                this.requestFull(this._model.instanceId);
            }
            // Only the clock and score bars move between server updates, so refresh those rather than
            // rebuilding the arena four times a second.
            this._view.tickArena(this._model);
        }

        function requestFull(instanceId:Int)
        {
            if (instanceId <= 0) return;
            var now= flash.Lib.getTimer();
            if (instanceId != this._lastFullRequestInstance || now - this._lastFullRequestAt >= FULL_REQUEST_BACKOFF_MS)
            {
                this.sendFullRequest(instanceId, now);
                return;
            }
            this._pendingFullRequestInstance = instanceId;
            if (this._fullRequestTimer == null)
            {
                this._fullRequestTimer = new Timer(1, 1);
                this._fullRequestTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onFullRequestTimer : ASAny));
            }
            this._fullRequestTimer.stop();
            this._fullRequestTimer.delay = Math.max(1,
                FULL_REQUEST_BACKOFF_MS - (now - this._lastFullRequestAt));
            this._fullRequestTimer.reset();
            this._fullRequestTimer.start();
        }

        function sendFullRequest(instanceId:Int, now:Int)
        {
            this._lastFullRequestInstance = instanceId;
            this._lastFullRequestAt = now;
            this._pendingFullRequestInstance = -1;
            this.send(new BattleBallRequestFullStatusComposer(instanceId));
        }

        function onFullRequestTimer(event:TimerEvent)
        {
            var instanceId= this._pendingFullRequestInstance;
            this._pendingFullRequestInstance = -1;
            if (instanceId > 0 && this._model != null && this._model.instanceId == instanceId)
                this.sendFullRequest(instanceId, flash.Lib.getTimer());
        }

        function clearPendingFullRequest(instanceId:Int)
        {
            if (this._pendingFullRequestInstance != instanceId) return;
            this._pendingFullRequestInstance = -1;
            if (this._fullRequestTimer != null) this._fullRequestTimer.stop();
        }

        function clearFullRequestState()
        {
            this._pendingFullRequestInstance = -1;
            this._lastFullRequestInstance = -1;
            this._lastFullRequestAt = -100000;
            if (this._fullRequestTimer != null)
            {
                this._fullRequestTimer.stop();
                this._fullRequestTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onFullRequestTimer : ASAny));
                this._fullRequestTimer = null;
            }
        }

        function send(composer:IMessageComposer)
        {
            if (this._communication != null && this._communication.connection != null) this._communication.connection.send(composer);
        }

        function handlePresentation(events:Array<ASAny>)
        {
var event:ASObject  = null;            if (events == null || this._assets == null) return;
            if (checkNullIteratee(events)) for (_tmp_ in events)
            {
event = _tmp_;
                if (event.type == 3) this.playEffect("hh_game_bb_SFX_18_poweruppickup");
                else if (event.type == 4) this.playEffect("hh_game_bb_SFX_10_stunned");
                else if (event.type == 5) this.playEffect("hh_game_bb__5sec_powerup_activation_v1");
            }
        }

        function playMusic()
        {
            this.stopMusic(); this._music = this._assets.play("hh_game_bb_BB2_musicloop", 999);
            this.syncMusicVolume();
        }

        function stopMusic() { if (this._music != null) { this._music.stop(); this._music = null; } }

        function playResult(winningTeam:Int)
        {
            var player:ASObject = this._model.localPlayer(this._session.userId);
            // The cast has no draw cue. Spectators and tied teams should not be told they lost.
            if (player == null || winningTeam < 0) return;
            this.playEffect(player.teamId == winningTeam
                ? "hh_game_bb_LS_C64_win_1" : "hh_game_bb_LS_C64_loose_1");
        }

        /** Game effects follow System; the looping soundtrack follows Jukebox. */
        function playEffect(name:String)
        {
            if (this._assets == null) return;
            var channel= this._assets.play(name);
            if (channel != null) channel.soundTransform = new SoundTransform(this.genericVolume);
        }

        function syncMusicVolume()
        {
            if (this._music != null) this._music.soundTransform = new SoundTransform(this.musicVolume);
        }

        var genericVolume(get,never):Float;
function  get_genericVolume():Float
        {
            return this._soundManager == null ? 1 : Math.max(0, Math.min(1, this._soundManager.genericVolume));
        }

        var musicVolume(get,never):Float;
function  get_musicVolume():Float
        {
            return this._soundManager == null ? 1 : Math.max(0, Math.min(1, this._soundManager.traxVolume));
        }

        function upsertInstance(value:ASObject)
        {
var             index = 0;            index= 0;while (index < this._instances.length)
                {if (this._instances[index].instanceId == value.instanceId) { this._instances[index] = value; return; }
;
index++;
}            this._instances.push(value);
        }

        function removeInstance(instanceId:Int)
        {
var index = 0;            for (_tmp_ in (0...this._instances.length).reverse())
{index= _tmp_;
                if (this._instances[index].instanceId == instanceId) this._instances.splice(index,1);
};
        }

        function findInstance(instanceId:Int):ASObject
        {
var value:ASObject  = null;            final _iter_ = this._instances; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) {value = _tmp_;
if (value.instanceId == instanceId) return value;
};
            return null;
        }

        function failureText(reason:Int):String
        {
            var keys:Array<ASAny> = ["bb_error_request", "bb_error_game_missing", "bb_error_owner_only",
                "bb_error_wrong_state", "bb_error_full", "bb_error_invalid_team", "bb_error_invalid_settings",
                "bb_error_not_enough_tickets", "bb_error_already_in_game", "bb_error_need_two_teams",
                "bb_error_not_player", "bb_error_action_not_allowed"];
            return this.text(reason >= 0 && reason < keys.length ? keys[reason] : keys[0]);
        }

        function removalText(reason:Int):String
        {
            var key= reason == 1 ? "bb_error_idle_removed" : "bb_error_kicked";
            var value= this.text(key);
            if (value != key) return value;
            return reason == 1 ? "You were removed from the game for inactivity."
                : "You were removed from the game by its owner.";
        }

        function text(key:String):String
        {
            if (this._localization == null) return key;
            var value= this._localization.getLocalization(key);
            return value == null || value == "" ? key : value;
        }
    }

