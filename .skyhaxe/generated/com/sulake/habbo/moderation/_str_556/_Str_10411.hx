package com.sulake.habbo.moderation._str_556
;
    import com.sulake.habbo.moderation.ModerationManager;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.friendlist.VisitUserMessageComposer;
    import com.sulake.core.window.events.WindowEvent;

     class _Str_10411 
    {
        var _Str_2327:ModerationManager;
        var _Str_2306:Int = 0;

        public function new(k:ModerationManager, _arg_2:IWindow, _arg_3:Int)
        {
            this._Str_2327 = k;
            this._Str_2306 = _arg_3;
            _arg_2.procedure = this.onClick;
        }

        function onClick(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._Str_2327.connection.send(new VisitUserMessageComposer(this._Str_2306));
        }
    }

