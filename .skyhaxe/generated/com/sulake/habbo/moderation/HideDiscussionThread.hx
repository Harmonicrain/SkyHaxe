package com.sulake.habbo.moderation
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.groupforums.ModerateThreadMessageComposer;
    import com.sulake.habbo.friendbar.groupforums.ForumModerationState;
    import com.sulake.core.window.events.WindowEvent;

     class HideDiscussionThread 
    {
        var _main:ModerationManager;
        var _popup:ChatlogCtrl;
        var _groupId:Int = 0;
        var _threadId:Int = 0;

        public function new(k:ModerationManager, _arg_2:ChatlogCtrl, _arg_3:IWindow, _arg_4:Int, _arg_5:Int)
        {
            this._main = k;
            this._popup = _arg_2;
            this._groupId = _arg_4;
            this._threadId = _arg_5;
            _arg_3.procedure = this.onClick;
        }

        function onClick(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._popup.dispose();
            this._main.connection.send(new ModerateThreadMessageComposer(this._groupId, this._threadId, ForumModerationState._Str_4415));
        }
    }

