package com.sulake.habbo.friendbar.groupforums
;
    import flash.utils.Timer;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.parser.groupforums.ForumData;
    import com.sulake.habbo.communication.messages.parser.groupforums.GuildForumThread;
    import flash.events.TimerEvent;
    import com.sulake.habbo.communication.messages.parser.groupforums.MessageData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowKeyboardEvent;
    import com.sulake.habbo.utils.FriendlyTime;

     class ComposeMessageView 
    {
        public static inline final _Str_16395= 10;
        public static inline final _Str_17431= 120;
        public static inline final _Str_16615= 10;
        public static inline final _Str_16284= 4000;
        public static final _Str_12067:Int = (30 * 1000);//30000

        var _controller:GroupForumController;
        var _mainView:GroupForumView;
        var _timer:Timer;
        var _window:IFrameWindow;
        var _subjectText:ITextFieldWindow;
        var _messageText:ITextFieldWindow;
        var _postButton:IWindow;
        var _status:IWindow;
        var _forumData:ForumData;
        var _threadData:GuildForumThread;
        var _hasErrors:Bool = false;
        var _posting:Bool = false;

        public function new(k:GroupForumView, _arg_2:Int, _arg_3:Int, _arg_4:ForumData, _arg_5:GuildForumThread, _arg_6:MessageData)
        {
            this._mainView = k;
            this._controller = this._mainView.controller;
            this._forumData = _arg_4;
            this._threadData = _arg_5;
            this._window = cast(this._controller.windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(Type.createInstance(HabboFriendBarCom.groupforum_compose_message_xml, []))), IFrameWindow);
            this._window.x = _arg_2;
            var _local_7= this._controller.windowManager.getDesktop(1).width;
            if ((this._window.x + this._window.width) > _local_7)
            {
                this._window.x = (_local_7 - this._window.width);
            }
            this._window.y = _arg_3;
            this._Str_7598(_arg_6);
            if (this._status.caption.length == 0)
            {
                this._status.caption = this._controller.localizationManager.getLocalization("groupforum.compose.reply_hint");
            }
            this._timer = new Timer(1000, 0);
            this._timer.addEventListener(TimerEvent.TIMER, (this.onTimerEvent : ASAny));
            this._timer.start();
        }

        public function focus(k:ForumData, _arg_2:GuildForumThread, _arg_3:MessageData)
        {
            if (!this._posting)
            {
                this._forumData = k;
                if (((!(this._threadData == null)) && (_arg_2 == null)))
                {
                    this._subjectText.text = "";
                }
                this._threadData = _arg_2;
                this._Str_7598(_arg_3);
            }
            this._window.activate();
        }

        function _Str_7598(k:MessageData)
        {
            var _local_2= GroupForumView._Str_14926(this._window, this._forumData);
            _local_2.removeEventListener(WindowMouseEvent.CLICK, this._Str_4912);
            _local_2.addEventListener(WindowMouseEvent.CLICK, this._Str_4912);
            var _local_3= this._window.findChildByName("thread_subject_header");
            this._subjectText = Std.downcast(this._window.findChildByName("thread_subject") , ITextFieldWindow);
            if (this._threadData != null)
            {
                _local_3.caption = this._controller.localizationManager.getLocalization("groupforum.compose.subject_replying_to");
                this._subjectText.text = this._threadData.header;
                this._subjectText.disable();
            }
            else
            {
                _local_3.caption = this._controller.localizationManager.getLocalization("groupforum.compose.subject");
                this._subjectText.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, this._Str_24345);
                this._subjectText.maxChars = _Str_17431;
                this._subjectText.enable();
            }
            this._messageText = Std.downcast(this._window.findChildByName("message_text") , ITextFieldWindow);
            this._messageText.removeEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, this._Str_20516);
            this._messageText.addEventListener(WindowKeyboardEvent.WINDOW_EVENT_KEY_UP, this._Str_20516);
            this._messageText.maxChars = _Str_16284;
            if (k != null)
            {
                this._Str_24168(k);
            }
            var _local_4= this._window.findChildByName("cancel_btn");
            _local_4.removeEventListener(WindowMouseEvent.CLICK, this._Str_4604);
            _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_4604);
            var _local_5= this._window.findChildByName("header_button_close");
            _local_5.removeEventListener(WindowMouseEvent.CLICK, this._Str_4604);
            _local_5.addEventListener(WindowMouseEvent.CLICK, this._Str_4604);
            this._postButton = this._window.findChildByName("post_btn");
            this._postButton.removeEventListener(WindowMouseEvent.CLICK, this._Str_10704);
            this._postButton.addEventListener(WindowMouseEvent.CLICK, this._Str_10704);
            this._status = this._window.findChildByName("status_text");
            this._Str_11234();
        }

        function _Str_24168(k:MessageData)
        {
            var _local_5:String = null;
            var _local_6:ASAny = null;
            var _local_2= new StringBuffer();
            _local_2.add(this._messageText.text);
            if (_local_2.length > 0)
            {
                _local_2.add("\r\r");
            }
            _local_2.add(this._controller.localizationManager.getLocalizationWithParams("groupforum.compose.reply_template", "", ["author_name", k._Str_6415, "creation_time", this._mainView._Str_11823(k._Str_6238)]));
            _local_2.add("\r");
            var _local_3:Array<ASAny> = (cast k.messageText.split("\r"));
            var _local_4 = false;
            if (checkNullIteratee(_local_3)) for (_tmp_ in _local_3)
            {
_local_5  = _tmp_;
                _local_6 = MessageListView._Str_13696.exec(_local_5);
                if (_local_6 != null)
                {
                    if (!_local_4)
                    {
                        _local_4 = true;
                        _local_2.add("> ").add(this._controller.localizationManager.getLocalization("groupforum.compose.skipped_quote")).add("\r");
                    }
                }
                else
                {
                    _local_2.add("> ").add(_local_5).add("\r");
                    _local_4 = false;
                }
            }
            _local_2.add("\r");
            this._messageText.text = _local_2.toString();
        }

        public function dispose()
        {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER, (this.onTimerEvent : ASAny));
            this._timer = null;
            this._controller._Str_10252 = null;
            this._window.dispose();
            this._window = null;
        }

        function onTimerEvent(k:TimerEvent)
        {
            this._Str_11234();
        }

        function _Str_24345(k:WindowKeyboardEvent)
        {
            this._Str_11234();
        }

        function _Str_20516(k:WindowKeyboardEvent)
        {
            this._Str_11234();
        }

        function _Str_4912(k:WindowMouseEvent)
        {
            this._controller.context.createLinkEvent(("group/" + Std.string(this._forumData.groupId)));
        }

        function _Str_10704(k:WindowMouseEvent)
        {
            if (this._posting)
            {
                return;
            }
            this._Str_11234();
            if (this._hasErrors)
            {
                return;
            }
            this._posting = true;
            this._subjectText.disable();
            this._messageText.disable();
            this._postButton.disable();
            this._status.caption = this._controller.localizationManager.getLocalization("groupforum.compose.posting");
            if (this._threadData != null)
            {
                this._controller._Str_24484(this._forumData.groupId, this._threadData.threadId, this._messageText.text);
            }
            else
            {
                this._controller._Str_23775(this._forumData.groupId, this._subjectText.text, this._messageText.text);
            }
        }

        function _Str_4604(k:WindowMouseEvent)
        {
            this.dispose();
        }

        function _Str_11234()
        {
            var k = 0;
            this._hasErrors = false;
            if (this._threadData == null)
            {
                if (this._subjectText.text.length <= _Str_16395)
                {
                    this._hasErrors = true;
                    this._status.caption = this._controller.localizationManager.getLocalization("groupforum.compose.subject_too_short");
                }
            }
            if (((!this._hasErrors) && (this._messageText.text.length <= _Str_16615)))
            {
                this._hasErrors = true;
                this._status.caption = this._controller.localizationManager.getLocalization("groupforum.compose.message_too_short");
            }
            if (((!this._hasErrors) && (!this._posting)))
            {
                k = (flash.Lib.getTimer() - this._controller._Str_25668);
                if (k < _Str_12067)
                {
                    this._hasErrors = true;
                    this._status.caption = this._controller.localizationManager.getLocalizationWithParams("groupforum.compose.post_cooldown", "", ["time_remaining", FriendlyTime.format(this._controller.localizationManager, (((_Str_12067 - k) / 1000) + 1), "", 1)]);
                }
            }
            if (((!this._posting) && (!this._hasErrors)))
            {
                this._postButton.enable();
                this._status.caption = "";
            }
            else
            {
                this._postButton.disable();
            }
        }
    }

