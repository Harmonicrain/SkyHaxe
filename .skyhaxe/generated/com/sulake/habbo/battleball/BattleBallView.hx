package com.sulake.habbo.battleball
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.ui.IRoomUI;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.habbo.window.utils.IAlertDialog;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.core.window.events.WindowEvent;

     final class BattleBallView implements IAvatarImageListener
    {
        /** Shared container for the arena and lobby windows; neither owns it. */
        var _host:BattleBallWindowHost;
        /** The shared lobby shell used by the list, create, game-info and standings screens. */
        var _shell:BattleBallLobbyWindow;
        /** Lobby history opens independently so the games list remains visible behind it. */
        var _historyShell:BattleBallLobbyWindow;
        /** Shared values more than one window needs: ticket cost and balance. */
        var _state:BattleBallViewState;
        var _finalScores:BattleBallFinalScoresRenderer;
        var _historicalScores:BattleBallFinalScoresRenderer;
        var _services:BattleBallViewServices;
        var _lobbyRenderer:BattleBallLobbyRenderer;
        var _createRenderer:BattleBallCreateRenderer;
        var _gameInfo:BattleBallGameInfoRenderer;
        /** The arena window. Owns the frame, HUD, name tags, pickups and board projection. */
        var _arenaWindow:BattleBallArenaWindow;
        var _session:ISessionDataManager;
        var _eventHandler:ASFunction;
        var _disposed:Bool = false;
        var _localization:IHabboLocalizationManager;
        var _windowManager:IHabboWindowManager;
        var _errorDialog:IAlertDialog;

        public function new(windowManager:IHabboWindowManager, assets:BattleBallAssets,
                                       componentAssets:IAssetLibrary,
                                       avatars:IAvatarRenderManager, session:ISessionDataManager,
                                       arena:BattleBallArena, roomUI:IRoomUI,
                                       localization:IHabboLocalizationManager,
                                       openTickets:ASFunction)
        {
            // Sources of data the facade's own behaviours read, before anything can call them.
            this._session = session;
            this._localization = localization;
            this._windowManager = windowManager;

            // The shared root, the window that hosts every lobby screen, and the two objects the
            // renderers are given.
            this._host = new BattleBallWindowHost(windowManager, roomUI);
            this._shell = new BattleBallLobbyWindow(windowManager, assets, componentAssets, this._host, this.text,
                this.hideArenaFrame, this.hideArenaNameTags, this.arenaPresent, this.inputChanged);
            this._historyShell = new BattleBallLobbyWindow(windowManager, assets, componentAssets, this._host, this.text,
                this.hideArenaFrame, this.hideArenaNameTags, this.arenaPresent, this.inputChanged);
            this._state = new BattleBallViewState();
            this._services = new BattleBallViewServices();

            // Behaviours the facade owns outright can be wired straight away.
            this._services.emit = this.emit; this._services.text = this.text;
            this._services.arenaName = this.arenaName;
            this._services.playerDisplayName = this.playerDisplayName;
            this._services.teamScore = this.teamScore;
            this._services.localUserId = this.localUserIdValue;
            this._services.redraw = this.emitRedraw;
            this._services.hide = this.hide;
            this._services.kickPlayer = this.kickFromArena;

            this._finalScores = new BattleBallFinalScoresRenderer(this._shell, this._state, this._services);
            this._historicalScores = new BattleBallFinalScoresRenderer(this._historyShell, this._state, this._services);
            this._lobbyRenderer = new BattleBallLobbyRenderer(this._shell, this._state, this._services);
            this._createRenderer = new BattleBallCreateRenderer(this._shell, this._state, this._services);
            this._gameInfo = new BattleBallGameInfoRenderer(this._shell, this._state, this._services);

            // The rest belong to renderers, so they can only be wired once those exist.
            this._services.openTickets = openTickets;
            this._services.showCreate = this._createRenderer.show;
            this._services.joinGame = this._gameInfo.joinGame;
            // Everything above is late-bound; this is the only thing that can catch a missing wire.
            this._services.assertWired();

            this._arenaWindow = new BattleBallArenaWindow(windowManager, assets, componentAssets,
                this._host, arena, this._services);
        }

        /** Every caption comes from external_dev_texts.txt under the key the Director layout declared. */
        function text(key:String):String
        {
            if (this._localization == null) return key;
            var value= this._localization.getLocalization(key);
            return value == null || value == "" ? key : value;
        }

        /**
         * Read lazily: the controller is built as soon as the session component is ready, which is well
         * before the user object arrives, so caching the id at construction would pin it to 0 forever.
         */
        var localUserId(get,never):Int;
function  get_localUserId():Int { return this._session == null ? 0 : this._session.userId; }

        public var visible(get,never):Bool;
public function  get_visible():Bool
        {
            return (this._arenaWindow != null && this._arenaWindow.frame != null && this._arenaWindow.frame.visible)
                || (this._shell.window != null && this._shell.window.visible)
                || (this._historyShell.window != null && this._historyShell.window.visible);
        }

        /** Takes the arena off screen without tearing down the room, ready to be shown again on re-entry. */
        public function hide()
        {
            this._arenaWindow.hideArenaFrame();
            this._shell.hide();
            this.closeHistoricalScores();
        }

        public function open() { this._arenaWindow.ensureWindow(); }

        /**
         * The lobby is put away here rather than by the arena window: which windows are on screen is
         * the facade's business, and it keeps the arena from calling back into this class.
         */
        public function showArena(model:BattleBallModel)
        {
            this._finalScores.invalidate();
            this.closeHistoricalScores();
            this._shell.hide();
            this._arenaWindow.show(model);
        }

        public function tickArena(model:BattleBallModel) { this._arenaWindow.tick(model); }

        public function showRules()
        {
            this.showError(this.text("bb_game_rules_text"));
        }

        public function showError(message:String)
        {
            if (this._arenaWindow != null && this._arenaWindow.frame != null
                && this._arenaWindow.frame.visible)
            {
                this._arenaWindow.showError(message);
                return;
            }
            this.closeErrorDialog();
            if (this._windowManager == null) return;
            var title= this.text("bb_error_title");
            if (title == "bb_error_title") title = "Battle Ball";
            this._errorDialog = this._windowManager.alert(title, message, 0, this.onErrorDialogClose);
        }

        public function openTickets()
        {
            if (this._services != null && this._services.openTickets != null)
                this._services.openTickets();
        }

        function closeErrorDialog()
        {
            if (this._errorDialog == null) return;
            this._errorDialog.dispose();
            this._errorDialog = null;
        }

        function onErrorDialogClose(dialog:IAlertDialog, event:WindowEvent)
        {
            if (dialog != null) dialog.dispose();
            if (this._errorDialog == dialog) this._errorDialog = null;
        }

        /** The renderer snapshots the finished round; nothing about it is kept here. */
        public function showFinalScores(model:BattleBallModel, instance:ASObject, ticketCost:Int,
                                        bestName:String, bestScore:Int)
        {
            this.closeHistoricalScores();
            this._state.ticketCost = ticketCost;
            this._finalScores.show(model, instance, ticketCost, bestName, bestScore);
        }

        /** Opens persisted results as a sibling window, leaving the games-list sidebar untouched. */
        public function showHistoricalScores(instance:ASObject, ticketCost:Int)
        {
            this._arenaWindow.hideArenaFrame();
            this._state.ticketCost = ticketCost;
            this._historicalScores.invalidate();
            this._historicalScores.showHistorical(instance, ticketCost);
        }

        public function closeHistoricalScores()
        {
            if (this._historyShell != null) this._historyShell.hide();
            if (this._historicalScores != null) this._historicalScores.resetSize();
        }

        /** Function reference for the arena window; localUserId itself is a getter. */
        function localUserIdValue():Int { return this.localUserId; }

        /**
         * Returning to the list clears what the other screens were showing: the game info selection
         * and the standings size. Those belong to their renderers, so the facade asks rather than
         * reaching in.
         */
        public function showLobby(instances:Array<ASAny>, ticketCost:Int, skillLevel:Int, error:String="")
        {
            this._state.ticketCost = ticketCost;
            this._gameInfo.reset();
            this._finalScores.resetSize();
            this._lobbyRenderer.show(instances, ticketCost, skillLevel, error);
        }

        public function showCreate(ticketCost:Int)
        {
            this.closeHistoricalScores();
            this._state.ticketCost = ticketCost;
            this._createRenderer.show(ticketCost);
        }

        public function showGameInfo(model:BattleBallModel, instance:ASObject, ticketCost:Int)
        {
            this._finalScores.invalidate();
            this.closeHistoricalScores();
            this._state.ticketCost = ticketCost;
            this._gameInfo.show(model, instance, ticketCost);
        }

        public function showJoinTeams(instanceId:Int, teams:Array<ASAny>)
        {
            this.closeHistoricalScores();
            this._gameInfo.showJoinTeams(instanceId, teams);
        }

        /**
         * Adapters for collaborators built before the renderers that own these actions. They keep
         * construction order simple without handing anyone a reference to this class.
         */
        function inputChanged(event:WindowEvent) { this._createRenderer.onLobbyInputChange(event); }
        function kickFromArena(userId:ASObject) { this._gameInfo.kickPlayer(userId); }

        /** Small adapters so the shell and arena never hold a reference to this class. */
        function hideArenaFrame() { this._arenaWindow.hideArenaFrame(); }
        function hideArenaNameTags() { this._arenaWindow.hidePlayerNameTags(); }
        function arenaPresent():Bool { return this._arenaWindow.frame != null; }

        /** Bots have negative ids and no stored name, so they are labelled from the cast's text. */
        function playerDisplayName(object:ASObject):String
        {
            if (object == null) return "";
            var userId= ASCompat.toInt(object.userId);
            if (userId < 0)
                return ASCompat.stringReplace(this.text("gs_bot_name"), "%index%", Std.string(-userId));
            return object.name == null ? "" : ASCompat.toString(object.name);
        }

        function emitRedraw(data:ASObject=null) { this.emit(BattleBallViewEvent.REDRAW); }

        public function setEventHandler(handler:ASFunction) { this._eventHandler = handler; }

        public function setTicketBalance(value:Int)
        {
            this._state.ticketBalance = value;
            this._lobbyRenderer.refreshTicketBalance();
            this._finalScores.refreshTicketBalance();
            this._historicalScores.refreshTicketBalance();
        }

        /**
         * Children first, then the shared root, so nothing is torn down while something still draws
         * into it. Each collaborator releases exactly what it created.
         */
        public function dispose()
        {
            this.closeErrorDialog();
            if (this._lobbyRenderer != null) { this._lobbyRenderer.dispose(); this._lobbyRenderer = null; }
            if (this._createRenderer != null) { this._createRenderer.dispose(); this._createRenderer = null; }
            if (this._gameInfo != null) { this._gameInfo.dispose(); this._gameInfo = null; }
            if (this._finalScores != null) { this._finalScores.dispose(); this._finalScores = null; }
            if (this._historicalScores != null) { this._historicalScores.dispose(); this._historicalScores = null; }
            if (this._historyShell != null) { this._historyShell.dispose(); this._historyShell = null; }
            if (this._shell != null) { this._shell.dispose(); this._shell = null; }
            if (this._arenaWindow != null) { this._arenaWindow.dispose(); this._arenaWindow = null; }
            if (this._host != null) { this._host.dispose(); this._host = null; }
            this._localization = null; this._session = null; this._windowManager = null; this._disposed = true;
        }

        /**
         * IAvatarImageListener contract, retained but inert.
         *
         * Players are drawn by BattleBallArena through the RoomEngine, so this view no longer builds
         * avatar images and never registers itself as a listener -- nothing can call this. The method
         * stays because the interface requires it.
         */
        public function avatarImageReady(figure:String)
        {
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }

        function teamScore(model:BattleBallModel, team:Int):Int
        {
            if (model == null || model.scores == null) return 0;
            var value:ASObject = model.scores[Std.string(team)];
            return value == null ? 0 : ASCompat.toInt(value);
        }

        /** The cast's own key prefix: the Lingo builds arena labels from bb_fieldname_<fieldType>. */
        function arenaName(mapId:Int):String
        {
            var key= "bb_fieldname_" + Std.string(mapId);
            var name= this.text(key);
            return name == key ? ASCompat.stringReplace(this.text("bb_fieldname_fallback"), "%id%", mapId) : name;
        }

        function emit(type:String, data:ASObject=null) { if(this._eventHandler!=null)this._eventHandler(new BattleBallViewEvent(type,data)); }

    }

