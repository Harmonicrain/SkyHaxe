package com.sulake.habbo.gamecenter
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.window.utils.IModalDialog;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextLinkWindow;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.game.GameAssetEnum;
    import com.sulake.core.assets.XmlAsset;

     class WaitingGameView implements IDisposable 
    {
        static inline final _Str_7257= 500;
        static inline final GAME_CENTER_WAITING_GAME_VIEW_XML= "game_center_waiting_game_view_xml";

        var _disposed:Bool = false;
        var _gameCenterView:GameCenterView;
        var _waitingGameDialog:IModalDialog;
        var _waitingGameWindow:IWindowContainer;
        var _logoImage:IStaticBitmapWrapperWindow;
        var _cancelLink:ITextLinkWindow;
        var _selectedGame:Int = 0;
        var _waitingGameTimer:Timer;
        var _counter:Int = 0;

        public function new(k:GameCenterView)
        {
            this._gameCenterView = k;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (this._waitingGameDialog != null)
            {
                this._waitingGameDialog.dispose();
                this._waitingGameDialog = null;
            }
            if (this._waitingGameTimer != null)
            {
                this._waitingGameTimer.removeEventListener(TimerEvent.TIMER, (this._Str_10599 : ASAny));
                this._waitingGameTimer.stop();
                this._waitingGameTimer = null;
            }
            if (this._cancelLink != null)
            {
                this._cancelLink.removeEventListener(WindowMouseEvent.CLICK, this._Str_26455);
            }
            this._cancelLink = null;
            this._logoImage = null;
            this._gameCenterView = null;
            this._disposed = true;
            this._counter = 0;
        }

        public function activate(k:Int)
        {
            this._counter = 0;
            this._selectedGame = k;
            if (this._waitingGameDialog == null)
            {
                this.createWindow();
            }
            this._waitingGameWindow.invalidate();
            this._waitingGameWindow.visible = true;
            this.updateLayout();
            this._gameCenterView._Str_3777(GameConfigurations.getNameId(this._selectedGame), "waitingGame");
            if (this._waitingGameTimer == null)
            {
                this._waitingGameTimer = new Timer(_Str_7257);
                this._waitingGameTimer.addEventListener(TimerEvent.TIMER, (this._Str_10599 : ASAny));
            }
            this._waitingGameTimer.start();
        }

        function updateLayout()
        {
            this._logoImage.assetUri = null;
            this._logoImage.assetUri = GameConfigurations.getAssetUrl(this._selectedGame, GameAssetEnum.LOGO);
        }

        function _Str_10599(k:TimerEvent)
        {
            if (this._waitingGameWindow == null)
            {
                return;
            }
            var _local_2= " ";
            var _local_3 = 0;
            while (_local_3 < (this._counter % 4))
            {
                _local_2 = (_local_2 + ".");
                _local_3++;
            }
            this._waitingGameWindow.caption = (this._gameCenterView.localization.getLocalization("gamecenter.waiting_game_title") + _local_2);
            this._counter++;
        }

        public function disable()
        {
            if (this._waitingGameDialog == null)
            {
                return;
            }
            this._waitingGameDialog.dispose();
            this._waitingGameDialog = null;
            this._waitingGameWindow = null;
            if (this._waitingGameTimer != null)
            {
                this._waitingGameTimer.stop();
            }
        }

        function onCloseHandler(k:WindowMouseEvent)
        {
            this._Str_26455(k);
        }

        function _Str_26455(k:WindowMouseEvent)
        {
            this._gameCenterView.leavePlayerQueue(this._selectedGame);
            this.disable();
            this._gameCenterView.activate(this._selectedGame, false);
            this._gameCenterView._Str_3777(GameConfigurations.getNameId(this._selectedGame), "waitingGameCancel");
        }

        function createWindow()
        {
            var k= this._gameCenterView.assets.getAssetByName(GAME_CENTER_WAITING_GAME_VIEW_XML);
            var _local_2= cast(k, XmlAsset);
            this._waitingGameDialog = this._gameCenterView.windowManager.buildModalDialogFromXML(new com.sulake.core.utils.xml.XML(_local_2.content));
            this._waitingGameWindow = Std.downcast(this._waitingGameDialog.rootWindow , IWindowContainer);
            this._waitingGameWindow.findChildByTag("close").addEventListener(WindowMouseEvent.CLICK, this.onCloseHandler);
            this._cancelLink = Std.downcast(this._waitingGameWindow.findChildByName("cancel_link") , ITextLinkWindow);
            this._cancelLink.addEventListener(WindowMouseEvent.CLICK, this._Str_26455);
            this._logoImage = Std.downcast(this._waitingGameWindow.findChildByName("logo_image") , IStaticBitmapWrapperWindow);
        }
    }

