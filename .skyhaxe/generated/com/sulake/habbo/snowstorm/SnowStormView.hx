package com.sulake.habbo.snowstorm
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.avatar.IAvatarRenderManager;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.session.ISessionDataManager;
    import com.sulake.habbo.ui.IRoomUI;
    import com.sulake.habbo.window.IHabboWindowManager;
    import flash.display.BitmapData;
    import com.sulake.habbo.window.utils.IAlertDialog;

    /** Small façade over the generated lobby/create/info/result renderers. */
     final class SnowStormView
    {
        var _windowManager:IHabboWindowManager;
        var _localization:IHabboLocalizationManager;
        var _session:ISessionDataManager;
        var _host:SnowStormWindowHost;
        var _shell:SnowStormLobbyWindow;
        var _historyShell:SnowStormLobbyWindow;
        var _state:SnowStormViewState;
        var _services:SnowStormViewServices;
        var _lobby:SnowStormLobbyRenderer;
        var _create:SnowStormCreateRenderer;
        var _gameInfo:SnowStormGameInfoRenderer;
        var _scores:SnowStormFinalScoresRenderer;
        var _historyScores:SnowStormFinalScoresRenderer;
        var _arena:SnowStormArena;
        var _arenaWindow:SnowStormArenaWindow;
        var _eventHandler:ASFunction;
        var _ticketDialog:ASFunction;
        var _error:IAlertDialog;
        var _disposed:Bool = false;

        public function new(windowManager:IHabboWindowManager, componentAssets:IAssetLibrary,
                                      assets:SnowStormAssets, session:ISessionDataManager,
                                      roomUI:IRoomUI, localization:IHabboLocalizationManager,
                                      ticketDialog:ASFunction, roomEngine:IRoomEngine,
                                      avatars:IAvatarRenderManager)
        {
            this._windowManager = windowManager;
            this._localization = localization;
            this._session = session;
            this._ticketDialog = ticketDialog;
            this._host = new SnowStormWindowHost(windowManager, roomUI);
            this._shell = new SnowStormLobbyWindow(windowManager, componentAssets, assets, this._host, this.text);
            this._historyShell = new SnowStormLobbyWindow(windowManager, componentAssets, assets, this._host, this.text);
            this._state = new SnowStormViewState();
            this._services = new SnowStormViewServices();
            this._services.emit = this.emit;
            this._services.text = this.text;
            this._services.mapName = this.mapName;
            this._services.localUserId = this.localUserId;
            this._services.redraw = this.redraw;
            this._services.openTickets = this.openTickets;
            this._services.assertWired();
            this._lobby = new SnowStormLobbyRenderer(this._shell, this._state, this._services);
            this._create = new SnowStormCreateRenderer(this._shell, this._state, this._services);
            this._gameInfo = new SnowStormGameInfoRenderer(this._shell, this._state, this._services);
            this._scores = new SnowStormFinalScoresRenderer(this._shell, this._state, this._services);
            this._historyScores = new SnowStormFinalScoresRenderer(this._historyShell, this._state, this._services);
            this._arena = new SnowStormArena(roomEngine, avatars, assets);
            this._arenaWindow = new SnowStormArenaWindow(windowManager, componentAssets, assets,
                avatars, session.figure, session.gender, this._host, this._arena,
                this.emit, this.text);
        }

        public function setEventHandler(handler:ASFunction)
        {
            this._eventHandler = handler;
        }

        public function showLobby(instances:Array<ASAny>, ticketCost:Int, skillLevel:Int)
        {
            this.hideArena(true);
            this._lobby.show(instances, ticketCost, skillLevel);
            this.raiseHistory();
        }

        public function resetLobbyPage()
        {
            if (this._lobby != null) this._lobby.resetPage();
        }

        public function showCreate(ticketCost:Int)
        {
            this.closeHistoricalScores();
            this._create.show(ticketCost);
        }

        public function showGameInfo(instance:ASObject, join:ASObject, ticketCost:Int)
        {
            this.closeHistoricalScores();
            this._gameInfo.show(instance, join, ticketCost);
        }

        public function showFinalScores(result:ASObject, model:SnowStormModel=null)
        {
            var portrait= this.bestPlayerImage(result, model);
            this.hideArena(false);
            this.closeHistoricalScores();
            this._scores.show(result, false, portrait);
        }

        public function showHistoricalScores(result:ASObject)
        {
            this._historyScores.show(result, true);
        }

        public function closeHistoricalScores()
        {
            if (this._historyShell != null) this._historyShell.hide();
        }

        function bestPlayerImage(result:ASObject, model:SnowStormModel):BitmapData
        {
var player:ASObject  = null;            if (result == null || result.players == null || this._arena == null) return null;
            var best:ASObject = null;
            final _iter_:ASAny = result.players; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
{player = _tmp_;
                if (best == null || ASCompat.toInt(player.score) > ASCompat.toInt(best.score) ||
                    (ASCompat.toInt(player.score) == ASCompat.toInt(best.score) && ASCompat.toInt(player.userId) < ASCompat.toInt(best.userId)))
                    best = player;
};
            return best == null ? null : this._arena.playerImage(model, ASCompat.toInt(best.userId));
        }

        public function showArena(model:SnowStormModel)
        {
            this.closeHistoricalScores();
            if (this._shell != null) this._shell.hide();
            if (this._arenaWindow != null) this._arenaWindow.show(model, this._state.ticketCost);
        }

        public function updateArena(model:SnowStormModel)
        {
            if (this._arenaWindow != null) this._arenaWindow.update(model);
        }

        public function showHit(worldX:Int, worldY:Int, worldZ:Int)
        {
            if (this._arena != null) this._arena.playHit(worldX, worldY, worldZ);
        }

        public function hideArena(release:Bool=false)
        {
            if (this._arenaWindow != null) this._arenaWindow.hide(release);
        }

        public function setTicketBalance(value:Int)
        {
            this._state.ticketBalance = value;
            this._lobby.refreshTicketBalance();
            this._gameInfo.refreshTicketBalance();
            this._scores.refreshTicketBalance();
            this._historyScores.refreshTicketBalance();
        }

        public function hide()
        {
            this.hideArena(true);
            if (this._shell != null) this._shell.hide();
            this.closeHistoricalScores();
        }

        public function raise()
        {
            if (this._shell != null) this._shell.raise();
            this.raiseHistory();
        }

        public function openTickets()
        {
            if (this._ticketDialog != null) this._ticketDialog();
        }

        public function showError(message:String)
        {
            this.closeError();
            // Gameplay rejections in Shockwave never interrupted the arena with a blocking dialog.
            // Keep them in the private window's bottom bar, as BattleBall already does.
            if (this._arenaWindow != null && this._arenaWindow.visible)
            {
                this._arenaWindow.showMessage(message);
                return;
            }
            if (this._windowManager == null) return;
            this._error = this._windowManager.alert(this.text("sw_error_title"),
                message, 0, this.onErrorClose);
        }

        public function showRules()
        {
            this.showError(this.text("sw_game_rules_text"));
        }

        public function showRankingsUnavailable()
        {
            this.showError(this.text("sw_highscores_loading"));
        }

        function localUserId():Int
        {
            return this._session == null ? 0 : this._session.userId;
        }

        function mapName(mapId:Int):String
        {
            var key= "sw_fieldname_" + Std.string(mapId);
            return this.text(key);
        }

        function text(key:String):String
        {
            // SnowStorm intentionally uses the compact singular heading rather than the shared
            // game-system copy, but it must remain independently localizable.
            if (key == "gs_header_gamelist") key = "sw_header_gamelist";
            if (this._localization == null) return key;
            var value= this._localization.getLocalization(key);
            return value == null || value == "" ? key : value;
        }

        function redraw()
        {
            this.emit(SnowStormViewEvent.REDRAW);
        }

        function emit(type:String, data:ASObject=null)
        {
            if (this._eventHandler != null)
                this._eventHandler(new SnowStormViewEvent(type, data));
        }

        function raiseHistory()
        {
            if (this._historyShell != null) this._historyShell.raise();
        }

        function closeError()
        {
            if (this._error != null) this._error.dispose();
            this._error = null;
        }

        function onErrorClose(dialog:IAlertDialog, event:WindowEvent)
        {
            if (dialog != null) dialog.dispose();
            if (this._error == dialog) this._error = null;
        }

        public function dispose()
        {
            if (this._disposed) return;
            this._disposed = true;
            this.closeError();
            if (this._historyScores != null) this._historyScores.dispose();
            if (this._arenaWindow != null) this._arenaWindow.dispose();
            if (this._arena != null) this._arena.dispose();
            if (this._scores != null) this._scores.dispose();
            if (this._gameInfo != null) this._gameInfo.dispose();
            if (this._create != null) this._create.dispose();
            if (this._lobby != null) this._lobby.dispose();
            if (this._historyShell != null) this._historyShell.dispose();
            if (this._shell != null) this._shell.dispose();
            if (this._host != null) this._host.dispose();
            this._historyScores = null;
            this._scores = null;
            this._gameInfo = null;
            this._create = null;
            this._lobby = null;
            this._historyShell = null;
            this._shell = null;
            this._host = null;
            this._services = null;
            this._state = null;
            this._eventHandler = null;
            this._arenaWindow = null;
            this._arena = null;
            this._ticketDialog = null;
            this._windowManager = null;
            this._localization = null;
            this._session = null;
        }
    }

