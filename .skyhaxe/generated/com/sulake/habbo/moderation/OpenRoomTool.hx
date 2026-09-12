package com.sulake.habbo.moderation
;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.window.utils.IAlertDialog;

     class OpenRoomTool 
    {
        var _frame:IFrameWindow;
        var _main:ModerationManager;
        var _roomId:Int = 0;

        public function new(k:IFrameWindow, _arg_2:ModerationManager, _arg_3:IWindow, _arg_4:Int)
        {
            this._frame = k;
            this._main = _arg_2;
            this._roomId = _arg_4;
            _arg_3.procedure = this.onClick;
        }

        function onClick(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._main.windowTracker.show(new RoomToolCtrl(this._main, this._roomId), this._frame, false, false, true);
        }

        function onAlertClose(k:IAlertDialog, _arg_2:WindowEvent)
        {
            k.dispose();
        }
    }

