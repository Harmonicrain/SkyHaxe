package com.sulake.habbo.ui.widget.furniture.gamehall
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.games.GameBoardMoveMessageComposer;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.ui.handler.GamehallWidgetHandler;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.habbo.window.IHabboWindowManager;
    import flash.display.Sprite;
    import flash.events.Event;

     class GamehallGameWidget extends RoomWidgetBase
    {
        var _boardWindow:GamehallBoardWindow;
        var _frame:IWindowContainer;
        var _panel:Sprite;
        var _gameAssets:GamehallAssetLibrary;
        var _view:GamehallGameView;
        var _stationId:Int = -1;
        var _gameType:String = "";
        var _localSeat:Int = 0;
        var _seatCount:Int = 0;

        public function new(handler:IRoomWidgetHandler, windowManager:IHabboWindowManager, assets:IAssetLibrary=null, localizations:IHabboLocalizationManager=null)
        {
            super(handler, windowManager, assets, localizations);
            cast(handler, GamehallWidgetHandler).widget = this;
            this._boardWindow = new GamehallBoardWindow(windowManager, assets);
        }

        override public function  get_mainWindow():IWindow
        {
            return this._boardWindow == null ? null : this._boardWindow.root;
        }

        public function open(stationId:Int, gameType:String="", localSeat:Int=0, seatCount:Int=0, verb:String="", args:Array<ASAny>=null, reason:String="")
        {
            this._stationId = stationId;
            this._gameType = gameType == null ? "" : gameType;
            this._localSeat = localSeat;
            this._seatCount = seatCount;
            this.createView();
            this.createFrame();
            this.ensureGameAssets();
            this.activateWindow();
            this.render();
            if (verb != "" || reason != "")
            {
                this.applyUpdate(this._stationId, verb, args, reason);
            }
        }

        public function applyUpdate(stationId:Int, verb:String="", args:Array<ASAny>=null, reason:String="")
        {
            if (stationId != this._stationId)
            {
                return;
            }
            var normalized= verb == null ? "" : verb.toUpperCase();
            if (normalized == GamehallUpdates.CLOSE)
            {
                this.close(stationId, reason);
                return;
            }
            if (this._view != null)
            {
                this._view.applyUpdate(normalized, args, reason);
            }
            this.render();
        }

        public function close(stationId:Int, reason:String="")
        {
            if (stationId != this._stationId)
            {
                return;
            }
            this.closeCurrent(reason);
        }

        function createView()
        {
            if (this._view != null)
            {
                this._view.dispose();
            }
            this._view = GamehallViewFactory.create(this._gameType, this.sendMove, this.render);
            this._view.reset(this._localSeat, this._seatCount);
        }

        function closeCurrent(reason:String="")
        {
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            this.destroyFrame();
            this._stationId = -1;
            this._gameType = "";
            this._localSeat = 0;
            this._seatCount = 0;
        }

        function createFrame()
        {
            this._panel = this._boardWindow.create(this.gameTitle(this._gameType), this.windowProcedure);
            this._frame = this._boardWindow.frame;
        }

        function destroyFrame()
        {
            if (this._boardWindow != null)
            {
                this._boardWindow.destroyFrame();
            }
            this._frame = null;
            this._panel = null;
        }

        function windowProcedure(event:WindowEvent, window:IWindow)
        {
            if (event.type == WindowMouseEvent.CLICK)
            {
                this.activateWindow();
            }
            if (event.type == WindowMouseEvent.CLICK && window != null && window.name == "header_button_close")
            {
                this.sendClose();
                return;
            }
            if (this._view != null)
            {
                this._view.handleWindowEvent(event, window);
            }
        }

        function sendClose()
        {
            if (this._stationId >= 0)
            {
                this.sendMove(GamehallCommands.CLOSE, []);
            }
            this.closeCurrent();
        }

        function sendMove(verb:String, args:Array<ASAny>)
        {
            var handler= Std.downcast(_handler , GamehallWidgetHandler);
            if (handler != null && handler.container != null && handler.container.connection != null)
            {
                handler.container.connection.send(new GameBoardMoveMessageComposer(this._stationId, verb, args));
            }
        }

        function ensureGameAssets()
        {
            if (this._gameAssets != null)
            {
                return;
            }
            var handler= Std.downcast(_handler , GamehallWidgetHandler);
            if (handler == null || handler.container == null || handler.container.config == null)
            {
                return;
            }
            var baseUrl= handler.container.config.getProperty("flash.client.url");
            if (baseUrl == null || baseUrl == "")
            {
                return;
            }
            this._gameAssets = new GamehallAssetLibrary();
            this._gameAssets.addEventListener(GamehallAssetLibrary.READY, (this.onGameAssetsReady : ASAny));
            this._gameAssets.addEventListener(GamehallAssetLibrary.ERROR, (this.onGameAssetsError : ASAny));
            this._gameAssets.load(baseUrl);
        }

        function onGameAssetsReady(event:Event)
        {
            this.render();
        }

        function onGameAssetsError(event:Event)
        {
            if (this._view != null)
            {
                this._view.applyUpdate("", null, "Board graphics unavailable");
            }
            this.render();
        }

        function render()
        {
            if (this._panel == null || this._frame == null || this._view == null)
            {
                return;
            }
            this._boardWindow.setFrameCaption(this.gameTitle(this._gameType));
            this._boardWindow.setTextVisible("start_title", false);
            this._boardWindow.setTextVisible("ok_link", false);
            this._boardWindow.setTextVisible("status_text", false);
            this._boardWindow.setTextVisible("turn_link", false);
            while (this._panel.numChildren > 0)
            {
                this._panel.removeChildAt(0);
            }
            this._panel.graphics.clear();
            this._view.render(this._panel, this._gameAssets);
        }

        function gameTitle(gameType:String):String
        {
            switch (GamehallGameTypes.normalize(gameType))
            {
                case GamehallGameTypes.TICTACTOE:
                    return "TicTacToe";
                case GamehallGameTypes.CHESS:
                    return "Chess";
                case GamehallGameTypes.POKER:
                    return "Poker";
                default:
                    return "Battleships";
            }
        }

        function activateWindow()
        {
            if (this._boardWindow != null)
            {
                this._boardWindow.activate();
            }
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            this.destroyFrame();
            if (this._boardWindow != null)
            {
                this._boardWindow.dispose();
                this._boardWindow = null;
            }
            if (this._gameAssets != null)
            {
                this._gameAssets.removeEventListener(GamehallAssetLibrary.READY, (this.onGameAssetsReady : ASAny));
                this._gameAssets.removeEventListener(GamehallAssetLibrary.ERROR, (this.onGameAssetsError : ASAny));
                this._gameAssets.dispose();
                this._gameAssets = null;
            }
            super.dispose();
        }
    }

