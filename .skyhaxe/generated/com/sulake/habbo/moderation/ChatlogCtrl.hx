package com.sulake.habbo.moderation
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import flash.utils.Timer;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.parser.moderation.IssueMessageData;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IFrameWindow;
    import flash.events.TimerEvent;
    import com.sulake.habbo.communication.messages.incoming.moderation.ChatRecordData;
    import com.sulake.habbo.communication.messages.incoming.moderation.ChatlineData;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.habbo.utils.StringUtil;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import com.sulake.core.window.events.WindowEvent;

     class ChatlogCtrl implements IDisposable implements  ITrackedWindow implements  IChatLogListener 
    {
        static var CHAT_LINE_POOL:Array<ASAny> = [];
        static var CHAT_LINE_POOL_MAX_SIZE:Int = 1000;
        static inline final CHAT_REPORTED_USER_COLOUR:UInt = 0xFFF0D6A3;
        static inline final CHAT_REPORTEE_COLOUR:UInt = 0xFFA3BDF0;

        var _type:Int = 0;
        var _id:Int = 0;
        var _msg:IMessageComposer;
        var _main:ModerationManager;
        var _frame:IWindowContainer;
        var _list:IItemListWindow;
        var _rooms:Array<ASAny>;
        var _embedded:Bool = false;
        var _disposed:Bool = false;
        var _contentLinePrototype:IWindowContainer;
        var _roomHeaderPrototype:IWindowContainer;
        var _hilitedUserIds:ASDictionary<ASAny,ASAny>;
        var _resizeTimer:Timer;
        var _chatLogUserIds:Map;
        var _issue:IssueMessageData;
        var _contentLines:Array<ASAny>;
        var _headers:Array<ASAny>;

        public function new(k:IMessageComposer, _arg_2:ModerationManager, _arg_3:Int, _arg_4:Int, _arg_5:IssueMessageData=null, _arg_6:IWindowContainer=null, _arg_7:IItemListWindow=null, _arg_8:Bool=false)
        {
            this._contentLines = [];
            this._headers = [];
            this._main = _arg_2;
            this._type = _arg_3;
            this._id = _arg_4;
            this._msg = k;
            this._chatLogUserIds = new Map();
            this._issue = _arg_5;
            this._frame = _arg_6;
            this._list = _arg_7;
            this._embedded = _arg_8;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function show()
        {
            var _local_3:IWindow = null;
            var k= cast(this._main.getXmlWindow("evidence_frame"), IFrameWindow);
            k.visible = false;
            var _local_2= cast(k.findChildByName("evidence_list"), IItemListWindow);
            this._roomHeaderPrototype = Std.downcast(_local_2.getListItemAt(0) , IWindowContainer);
            this._contentLinePrototype = Std.downcast(_local_2.getListItemAt(1) , IWindowContainer);
            _local_2.removeListItems();
            this._resizeTimer = new Timer(1000, 1);
            this._resizeTimer.addEventListener(TimerEvent.TIMER, (this.onResizeTimer : ASAny));
            if (!this._embedded)
            {
                this._frame = k;
                this._frame.procedure = this.onWindow;
                this._frame.visible = true;
                _local_3 = this._frame.findChildByTag("close");
                _local_3.procedure = this.onClose;
                this._list = _local_2;
            }
            else
            {
                k.dispose();
            }
            this._main.connection.send(this._msg);
            this._main.moderationMessageHandler.addChatlogListener(this);
        }

        public function hide()
        {
            this.dispose();
        }

        public function onChatlog(k:String, _arg_2:Int, _arg_3:Int, _arg_4:Array<ASAny>, _arg_5:ASDictionary<ASAny,ASAny>)
        {
            var _local_6:IWindowContainer = null;
            if ((((!(_arg_2 == this._type)) || (!(_arg_3 == this._id))) || this._disposed))
            {
                return;
            }
            final _iter_ = this._contentLines; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_6  = _tmp_;
                this.recycleContentLine(_local_6);
            }
            final _iter_ = this._headers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_6  = _tmp_;
                _local_6.dispose();
            }
            this._contentLines = [];
            this._headers = [];
            this._main.moderationMessageHandler.removeChatlogListener(this);
            this._rooms = _arg_4;
            this._hilitedUserIds = _arg_5;
            this.populate();
            this.onResizeTimer(null);
            if (!this._embedded)
            {
                this._frame.caption = k;
                this._frame.visible = true;
            }
        }

        public function getType():Int
        {
            return this._type;
        }

        public function getId():String
        {
            return "" + Std.string(this._id);
        }

        public function setId(k:Int)
        {
            this._id = k;
        }

        public function getFrame():IFrameWindow
        {
            return Std.downcast(this._frame , IFrameWindow);
        }

        function populate()
        {
            var k:ChatRecordData = null;
            this._list.autoArrangeItems = false;
            this._list.removeListItems();
            final _iter_ = this._rooms; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                this.populateEvidence(k);
            }
            this._list.autoArrangeItems = true;
        }

        function populateEvidence(k:ChatRecordData)
        {
            var _local_9:String = null;
            var _local_10:ChatlineData = null;
            var _local_2= this.createHeaderLine();
            var _local_3= _local_2.findChildByName("text");
            var _local_4= cast(_local_2.findChildByName("btnHeaderAction"), IButtonWindow);
            var _local_5= cast(_local_2.findChildByName("btnHeaderAction2"), IButtonWindow);
            if (_local_5 != null)
            {
                _local_5.visible = false;
            }
            switch (k.recordType)
            {
                case ChatRecordData.TYPE_ROOM_CHAT:
                    if (k.roomId > 0)
                    {
                        _local_4.caption = "Room tool";
                        if (k.roomName == null)
                        {
                            _local_3.caption = ("Room #" + Std.string(k.roomId));
                        }
                        else
                        {
                            _local_3.caption = ("Room: " + k.roomName);
                        }
                        _local_5.visible = true;
                        _local_5.caption = "View room";
                        new OpenRoomInSpectatorMode(this._main, _local_5, k.roomId);
                        if (this._embedded)
                        {
                            new OpenRoomTool(null, this._main, _local_4, k.roomId);
                        }
                        else
                        {
                            new OpenRoomTool(Std.downcast(this._frame , IFrameWindow), this._main, _local_4, k.roomId);
                        }
                    }
                    
                case ChatRecordData.TYPE_IM_SESSION:
                    _local_3.caption = "IM session";
                    
                case ChatRecordData.TYPE_DISCUSSION_THREAD:
                    _local_3.caption = "Forum thread";
                    _local_5.visible = true;
                    _local_5.caption = "Open thread";
                    new OpenDiscussionThread(this._main, _local_5, k.groupId, k.threadId);
                    _local_4.caption = "Delete";
                    new HideDiscussionThread(this._main, this, _local_4, k.groupId, k.threadId);
                    
                case ChatRecordData.TYPE_DISCUSSION_MESSAGE:
                    _local_3.caption = "Forum message";
                    _local_5.visible = true;
                    _local_5.caption = "Open Message";
                    new OpenDiscussionMessage(this._main, _local_5, k.groupId, k.threadId, ASCompat.toInt(k.context["messageIndex"]));
                    _local_4.caption = "Delete";
                    new HideDiscussionMessage(this._main, this, _local_4, k.groupId, k.threadId, k.messageId);
                    
                case ChatRecordData._Str_7751:
                    _local_3.caption = "Selfie report";
                    _local_5.visible = true;
                    _local_5.caption = "View selfie";
                    new OpenExternalLink(this._main, _local_5, k.context["url"]);
                    _local_4.visible = true;
                    _local_4.caption = "Room tool";
                    if (this._embedded)
                    {
                        new OpenRoomTool(null, this._main, _local_4, k.roomId);
                    }
                    else
                    {
                        new OpenRoomTool(Std.downcast(this._frame , IFrameWindow), this._main, _local_4, k.roomId);
                    }
                    
                case ChatRecordData._Str_17666:
                    _local_3.caption = "Photo report";
                    _local_5.visible = true;
                    _local_5.caption = "Moderate photo";
                    _local_9 = this._main.getProperty("stories.admin.tool.base.url");
                    if (StringUtil.isEmpty(_local_9))
                    {
                        _local_9 = "https://theallseeingeye.sulake.com/habbo-stories-admin/#/photos/";
                    }
                    _local_9 = (_local_9 + k.context["extraDataId"]);
                    new OpenExternalLink(this._main, _local_5, _local_9);
                    _local_4.visible = true;
                    _local_4.caption = "Room tool";
                    if (this._embedded)
                    {
                        new OpenRoomTool(null, this._main, _local_4, k.roomId);
                    }
                    else
                    {
                        new OpenRoomTool(Std.downcast(this._frame , IFrameWindow), this._main, _local_4, k.roomId);
                    }
                    
            }
            this.addHeaderLineToList(_local_2);
            var _local_6= true;
            var _local_7= -1;
            var _local_8 = 0;
            while (_local_8 < k.chatlog.length)
            {
                _local_10 = k.chatlog[_local_8];
                this.populateContentLine(_local_10, _local_6);
                _local_6 = (!_local_6);
                if ((_local_10._Str_19967 && (_local_7 == -1)))
                {
                    _local_7 = _local_8;
                }
                _local_8++;
            }
            if (_local_7 > -1)
            {
                this._list.autoArrangeItems = true;
                if (this._list.maxScrollV > 0)
                {
                    this._list.scrollV = (this._list.getListItemAt(_local_7).y / this._list.maxScrollV);
                }
            }
        }

        function addContentLineToList(k:IWindowContainer)
        {
            this._list.addListItem(k);
            this._contentLines.push(k);
        }

        function addHeaderLineToList(k:IWindowContainer)
        {
            this._list.addListItem(k);
            this._headers.push(k);
        }

        function createContentLine():IWindowContainer
        {
            if (CHAT_LINE_POOL.length > 0)
            {
                return ASCompat.dynamicAs(CHAT_LINE_POOL.pop() , IWindowContainer);
            }
            return cast(this._contentLinePrototype.clone(), IWindowContainer);
        }

        function recycleContentLine(k:IWindowContainer)
        {
            var _local_2:ITextWindow = null;
            if (CHAT_LINE_POOL.length < CHAT_LINE_POOL_MAX_SIZE)
            {
                _local_2 = cast(k.findChildByName("chatter_txt"), ITextWindow);
                _local_2.removeEventListener(WindowMouseEvent.CLICK, this.onUserClick);
                k.width = this._contentLinePrototype.width;
                k.height = (this._contentLinePrototype.height - 10);
                CHAT_LINE_POOL.push(k);
            }
            else
            {
                k.dispose();
            }
        }

        function createHeaderLine():IWindowContainer
        {
            return Std.downcast(this._roomHeaderPrototype.clone() , IWindowContainer);
        }

        function populateContentLine(k:ChatlineData, _arg_2:Bool)
        {
            var _local_9:TextFormat = null;
            var _local_3= this.createContentLine();
            var _local_4= _local_3.findChildByName("time_txt");
            var _local_5= cast(_local_3.findChildByName("chatter_txt"), ITextWindow);
            var _local_6= Std.downcast(_local_3.findChildByName("msg_txt") , ITextWindow);
            _local_4.caption = k.timeStamp;
            var _local_7:ASAny = this._hilitedUserIds[k._Str_13143];
            if (_local_7 != null)
            {
                _local_3.color = ((ASCompat.asInt(_local_7 ) == 0) ? CHAT_REPORTED_USER_COLOUR : CHAT_REPORTEE_COLOUR);
            }
            else
            {
                _local_3.color = (_arg_2 ? 0xFFC3ECFA : 0xFFFFFFFF);
            }
            if (k._Str_19967)
            {
                _local_9 = _local_6.getTextFormat();
                _local_9.bold = true;
                _local_6.setTextFormat(_local_9);
                _local_6.bold = true;
            }
            if (k._Str_13143 > 0)
            {
                _local_5.text = k._Str_18796;
                _local_5.underline = true;
                _local_5.addEventListener(WindowMouseEvent.CLICK, this.onUserClick);
                if (!this._chatLogUserIds.getValue(k._Str_18796))
                {
                    this._chatLogUserIds.add(k._Str_18796, k._Str_13143);
                }
            }
            else
            {
                if (k._Str_13143 == 0)
                {
                    _local_5.text = "Bot / pet";
                    _local_5.underline = false;
                }
                else
                {
                    _local_5.text = "-";
                    _local_5.underline = false;
                }
            }
            _local_5.color = _local_3.color;
            _local_4.color = _local_3.color;
            _local_6.color = _local_3.color;
            _local_6.text = k._Str_23429;
            var _local_8= Std.int(Math.max(_local_4.height, (_local_6.textHeight + 5)));
            _local_6.height = _local_8;
            if (_local_6.getTextFormat() != null)
            {
                _local_6.getTextFormat().align = TextFormatAlign.LEFT;
                _local_6.getTextFormat().rightMargin = (ASCompat.toInt(_local_6.getTextFormat().rightMargin) + 10);
            }
            _local_5.height = _local_8;
            _local_4.height = _local_8;
            _local_3.height = _local_8;
            this.addContentLineToList(_local_3);
        }

        function onUserClick(k:WindowMouseEvent)
        {
            var _local_2= k.target.caption;
            var _local_3= ASCompat.toInt(this._chatLogUserIds.getValue(_local_2));
            this._main.windowTracker.show(new UserInfoFrameCtrl(this._main, _local_3, this._issue), Std.downcast(this._frame , IFrameWindow), false, false, true);
        }

        function onClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.dispose();
        }

        function onWindow(k:WindowEvent, _arg_2:IWindow)
        {
            if (((!(k.type == WindowEvent.WINDOW_EVENT_RESIZED)) || (!((_arg_2 : ASAny) == (this._frame : ASAny)))))
            {
                return;
            }
            this._resizeTimer.reset();
            this._resizeTimer.start();
        }

        function onResizeTimer(k:TimerEvent)
        {
            this.refreshListDims();
            var _local_2= this.refreshScrollBarVisibility();
        }

        function refreshListDims()
        {
            var k:IWindowContainer = null;
            var _local_2:ITextWindow = null;
            this._list.autoArrangeItems = false;
            var _local_3= this._list.numListItems;
            var _local_4 = 0;
            while (_local_4 < _local_3)
            {
                k = cast(this._list.getListItemAt(_local_4), IWindowContainer);
                if (k.name == "chatline")
                {
                    _local_2 = cast(k.findChildByName("msg_txt"), ITextWindow);
                    _local_2.width = (k.width - _local_2.x);
                    _local_2.height = Std.int(_local_2.textHeight + 5);
                    k.height = _local_2.height;
                }
                _local_4++;
            }
            this._list.autoArrangeItems = true;
        }

        function refreshScrollBarVisibility():Bool
        {
            var k= cast(this._list.parent, IWindowContainer);
            var _local_2= k.getChildByName("scroller") ;
            var _local_3:ASAny = (this._list.scrollableRegion.height > this._list.height);
            var _local_4= 22;
            if (_local_2.visible)
            {
                if (_local_3)
                {
                    return false;
                }
                _local_2.visible = false;
                this._list.width = (this._list.width + _local_4);
                return true;
            }
            if (_local_3)
            {
                _local_2.visible = true;
                this._list.width = (this._list.width - _local_4);
                return true;
            }
            return false;
        }

        public function dispose()
        {
            var k:IWindowContainer = null;
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            this._main = null;
            this._msg = null;
            this._issue = null;
            if (this._list != null)
            {
                this._list.removeListItems();
                this._list.dispose();
                this._list = null;
            }
            if (this._frame != null)
            {
                this._frame.destroy();
                this._frame = null;
            }
            this._rooms = null;
            this._hilitedUserIds = null;
            if (this._resizeTimer != null)
            {
                this._resizeTimer.stop();
                this._resizeTimer.removeEventListener(TimerEvent.TIMER, (this.onResizeTimer : ASAny));
                this._resizeTimer = null;
            }
            if (!this._embedded)
            {
                final _iter_ = this._contentLines; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    this.recycleContentLine(k);
                }
                final _iter_ = this._headers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
k  = _tmp_;
                    k.dispose();
                }
            }
            this._contentLines = [];
            this._headers = [];
            if (this._contentLinePrototype != null)
            {
                this._contentLinePrototype.dispose();
                this._contentLinePrototype = null;
            }
            if (this._roomHeaderPrototype != null)
            {
                this._roomHeaderPrototype.dispose();
                this._roomHeaderPrototype = null;
            }
        }
    }

