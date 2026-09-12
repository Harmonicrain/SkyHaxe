package com.sulake.habbo.ui.widget.furniture.friendfurni
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.ui.handler.FriendFurniConfirmWidgetHandler;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class FriendFurniConfirmWidget extends RoomWidgetBase
    {
        var _stuffId:Int = -1;
        var _window:IFrameWindow;
        var _otherLockedContainerHeight:Int = -1;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager)
        {
            super(k, _arg_2, _arg_3, _arg_4);
            this._Str_14761.widget = this;
        }

        override public function dispose()
        {
            this._stuffId = -1;
            this.destroyWindow();
            super.dispose();
        }

        override public function  get_mainWindow():IWindow
        {
            return this._window;
        }

        public function open(k:Int, _arg_2:Bool)
        {
            if ((((this._window != null) && this._window.visible) && (!(this._stuffId == -1))))
            {
                this._Str_14761.sendLockConfirm(this._stuffId, false);
                this.destroyWindow();
            }
            this._stuffId = k;
            this.createWindow();
            if (!_arg_2)
            {
                this._window.findChildByName("other_locked_container").height = 0;
            }
            else
            {
                this._window.findChildByName("other_locked_container").height = this._otherLockedContainerHeight;
                this._window.findChildByName("message").visible = false;
            }
            this.mainWindow.visible = true;
        }

        public function close(k:Int)
        {
            if (k == this._stuffId)
            {
                this.destroyWindow();
            }
        }

        public function _Str_25728(k:Int)
        {
            if (((!(this._window == null)) && (k == this._stuffId)))
            {
                cast(this._window.findChildByName("lock"), IStaticBitmapWrapperWindow).assetUri = "${image.library.url}furniextras/locked_image.png";
                this._window.findChildByName("message").visible = true;
            }
        }

        function createWindow()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = cast(windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(assets.getAssetByName("lock_confirm_xml").content)), IFrameWindow);
            this._window.procedure = this.windowProcedure;
            this._otherLockedContainerHeight = this._window.findChildByName("other_locked_container").height;
            this._window.center();
        }

        function destroyWindow()
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        var _Str_14761(get,never):FriendFurniConfirmWidgetHandler;
function  get__Str_14761():FriendFurniConfirmWidgetHandler
        {
            return cast(_handler, FriendFurniConfirmWidgetHandler);
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "header_button_close"
                       | "cancel_button":
                        this._Str_14761.sendLockConfirm(this._stuffId, false);
                        this.destroyWindow();
                        return;
                    case "confirm_button":
                        this._Str_14761.sendLockConfirm(this._stuffId, true);
                        this.destroyWindow();
                        return;
                }
            }
        }
    }

