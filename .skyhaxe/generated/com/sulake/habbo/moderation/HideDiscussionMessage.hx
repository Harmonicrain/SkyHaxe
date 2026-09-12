package com.sulake.habbo.moderation
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.groupforums.ModerateMessageMessageComposer;
    import com.sulake.habbo.friendbar.groupforums.ForumModerationState;
    import com.sulake.core.window.events.WindowEvent;

     class HideDiscussionMessage 
    {
        var _main:ModerationManager;
        var _popup:ChatlogCtrl;
        var _groupId:Int = 0;
        var _threadId:Int = 0;
        var _messageId:Int = 0;

        public function new(k:ModerationManager, _arg_2:ChatlogCtrl, _arg_3:IWindow, _arg_4:Int, _arg_5:Int, _arg_6:Int)
        {
            this._main = k;
            this._popup = _arg_2;
            this._groupId = _arg_4;
            this._threadId = _arg_5;
            this._messageId = _arg_6;
            _arg_3.procedure = this.onClick;
        }

        function onClick(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._popup.dispose();
            this._main.connection.send(new ModerateMessageMessageComposer(this._groupId, this._threadId, this._messageId, ForumModerationState._Str_4415));
        }
    }

