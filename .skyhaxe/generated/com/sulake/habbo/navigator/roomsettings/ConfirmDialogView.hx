package com.sulake.habbo.navigator.roomsettings
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.navigator.Util;
    import com.sulake.habbo.navigator.IHabboTransitionalNavigator;

     class ConfirmDialogView implements IDisposable 
    {
        var _window:IFrameWindow;
        var _okHandler:ASFunction;

        public function new(k:IHabboTransitionalNavigator, _arg_2:ASFunction, _arg_3:String, _arg_4:String)
        {
            this._window = cast(k.getXmlWindow("ros_confirm"), IFrameWindow);
            this._okHandler = _arg_2;
            this._window.findChildByTag("close").addEventListener(WindowMouseEvent.CLICK, this._Str_26455);
            this._window.findChildByName("ok").addEventListener(WindowMouseEvent.CLICK, this._Str_6167);
            this._window.caption = _arg_3;
            this._window.findChildByName("message").caption = _arg_4;
            var _local_5= Util._Str_10228(this._window.desktop, this._window.width, this._window.height);
            this._window.x = Std.int(_local_5.x);
            this._window.y = Std.int(_local_5.y);
            this._window.visible = true;
            this._window.activate();
        }

        function _Str_26455(k:WindowMouseEvent)
        {
            this.dispose();
        }

        function _Str_6167(k:WindowMouseEvent)
        {
            this._okHandler();
            this.dispose();
        }

        public function dispose()
        {
            if (this._window != null)
            {
                this._window.destroy();
                this._window = null;
            }
            this._okHandler = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._window == null;
        }
    }

