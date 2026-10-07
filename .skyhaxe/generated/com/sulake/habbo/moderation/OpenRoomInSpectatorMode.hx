package com.sulake.habbo.moderation
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class OpenRoomInSpectatorMode 
    {
        var _main:ModerationManager;
        var _roomId:Int = 0;

        public function new(k:ModerationManager, _arg_2:IWindow, _arg_3:Int)
        {
            this._main = k;
            this._roomId = _arg_3;
            _arg_2.procedure = this.onClick;
        }

        function onClick(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._main.goToRoom(this._roomId);
        }
    }

