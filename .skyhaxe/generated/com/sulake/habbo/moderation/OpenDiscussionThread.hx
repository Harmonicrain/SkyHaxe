package com.sulake.habbo.moderation
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class OpenDiscussionThread 
    {
        var _main:ModerationManager;
        var _groupId:Int = 0;
        var _threadId:Int = 0;

        public function new(k:ModerationManager, _arg_2:IWindow, _arg_3:Int, _arg_4:Int)
        {
            this._main = k;
            this._groupId = _arg_3;
            this._threadId = _arg_4;
            _arg_2.procedure = this.onClick;
        }

        function onClick(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._main.openThread(this._groupId, this._threadId);
        }
    }

