package com.sulake.habbo.help
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.help.CallForHelpReplyMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.CallForHelpResultMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.IssueCloseNotificationMessageEvent;
    import com.sulake.habbo.help._enum._Str_2849;
    import com.sulake.habbo.communication.messages.outgoing.help.CallForHelpFromSelfieMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.help.CallForHelpFromPhotoMessageComposer;
    import com.sulake.core.window.components.ISelectableWindow;
    import com.sulake.habbo.window.widgets.IIlluminaInputWidget;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ISelectorWindow;
    import com.sulake.habbo.help.cfh.registry.user.UserRegistryItem;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.outgoing.users.IgnoreUserIdMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.help.ChatReviewSessionCreateMessageComposer;
    import com.sulake.habbo.window._enum.HabboAlertDialogFlag;
    import com.sulake.habbo.communication.messages.outgoing.help.CallForHelpMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.help.CallForHelpFromIMMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.help.CallForHelpFromForumThreadMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.help.CallForHelpFromForumMessageMessageComposer;
    import com.sulake.habbo.window.utils.IAlertDialog;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.help._enum.CallForHelpResultEnum;
    import com.sulake.habbo.communication.messages.outgoing.help.DeletePendingCallsForHelpMessageComposer;

     class CallForHelpManager implements IDisposable 
    {
        static inline final FIELD_MAX_CHARS= 253;
        static inline final EMERGENCY_HELP_REQUEST= "emergency_help_request";

        var _disposed:Bool = false;
        var _habboHelp:HabboHelp;
        var _window:IWindowContainer;
        var _chatReportController:ChatReportController;
        var _reportedUserId:Int = -1;
        var _reportedUserName:String = "";
        var _reportedRoomId:Int = -1;
        var _reportedRoomName:String;
        var _reportedRoomDescription:String;
        var _reportedGroupId:Int = -1;
        var _reportedThreadId:Int = -1;
        var _reportedMessageId:Int = -1;
        var _reportedExtraDataId:String;
        var _reportedRoomObjectId:Int = -1;
        var _reportType:Int = 0;
        var _incomingTopic:Int = 0;
        var _topicIndex:Int = 0;
        var _message:String;

        public function new(k:HabboHelp)
        {
            this._habboHelp = k;
            this._chatReportController = new ChatReportController(this._habboHelp, this.onChatReportEvent);
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new CallForHelpReplyMessageEvent(this.onCallForHelpReply));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new CallForHelpResultMessageEvent(this.onCallForHelpResult));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new IssueCloseNotificationMessageEvent(this.onIssueClose));
        }

        static function getCloseReasonKey(k:Int):String
        {
            if (k == 1)
            {
                return "useless";
            }
            if (k == 2)
            {
                return "abusive";
            }
            return "resolved";
        }


        public function dispose()
        {
            if (!this._disposed)
            {
                this.closeWindow();
                if (this._chatReportController != null)
                {
                    this._chatReportController.dispose();
                    this._chatReportController = null;
                }
                this._habboHelp = null;
                this._disposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        
        public var reportedUserId(get,set):Int;
public function  get_reportedUserId():Int
        {
            return this._reportedUserId;
        }

        
        public var reportedUserName(get,set):String;
public function  get_reportedUserName():String
        {
            return this._reportedUserName;
        }

        
        public var _Str_3469(get,set):Int;
public function  get__Str_3469():Int
        {
            return this._reportedRoomId;
        }

        
        public var _Str_16366(get,set):String;
public function  get__Str_16366():String
        {
            return this._reportedRoomName;
        }

        
        public var _Str_11455(get,set):String;
public function  get__Str_11455():String
        {
            return this._reportedExtraDataId;
        }

        
        public var _Str_10658(get,set):Int;
public function  get__Str_10658():Int
        {
            return this._reportedRoomObjectId;
        }

        
        public var _Str_11420(get,set):Int;
public function  get__Str_11420():Int
        {
            return this._reportedGroupId;
        }

        
        public var _Str_10392(get,set):Int;
public function  get__Str_10392():Int
        {
            return this._reportedThreadId;
        }

        
        public var _Str_16155(get,set):Int;
public function  get__Str_16155():Int
        {
            return this._reportedMessageId;
        }
public function  set_reportedUserId(k:Int):Int        {
            return this._reportedUserId = k;
        }
public function  set_reportedUserName(k:String):String        {
            return this._reportedUserName = k;
        }
public function  set__Str_3469(k:Int):Int        {
            return this._reportedRoomId = k;
        }
public function  set__Str_16366(k:String):String        {
            return this._reportedRoomName = k;
        }
public function  set__Str_11455(k:String):String        {
            return this._reportedExtraDataId = k;
        }
public function  set__Str_10658(k:Int):Int        {
            return this._reportedRoomObjectId = k;
        }
public function  set__Str_11420(k:Int):Int        {
            return this._reportedGroupId = k;
        }
public function  set__Str_10392(k:Int):Int        {
            return this._reportedThreadId = k;
        }
public function  set__Str_16155(k:Int):Int        {
            return this._reportedMessageId = k;
        }

        public function reportBully(k:Int, _arg_2:Int)
        {
            if (this._habboHelp._Str_16486)
            {
                this._reportedUserId = k;
                this._reportedRoomId = _arg_2;
                this._habboHelp.queryForGuideReportingStatus(_Str_2849._Str_8260);
            }
            else
            {
                this.reportUser(k, HabboHelp.REPORT_TYPE_EMERGENCY, 123);
            }
        }

        public function reportUser(k:Int, _arg_2:Int, _arg_3:Int)
        {
            this._reportedUserId = k;
            this._reportedRoomId = -1;
            this._incomingTopic = _arg_3;
            this._habboHelp.queryForPendingCallsForHelp(_arg_2);
        }

        public function reportRoom(k:Int, _arg_2:String, _arg_3:String)
        {
            this._reportedRoomId = k;
            this._reportedRoomName = _arg_2;
            this._reportedRoomDescription = _arg_3;
            this._reportedUserId = -1;
            this._habboHelp.queryForPendingCallsForHelp(HabboHelp.REPORT_TYPE_ROOM);
        }

        public function reportThread(k:Int, _arg_2:Int)
        {
            this._reportedGroupId = k;
            this._reportedThreadId = _arg_2;
            this._habboHelp.queryForPendingCallsForHelp(HabboHelp.REPORT_TYPE_THREAD);
        }

        public function reportMessage(k:Int, _arg_2:Int, _arg_3:Int)
        {
            this._reportedGroupId = k;
            this._reportedThreadId = _arg_2;
            this._reportedMessageId = _arg_3;
            this._habboHelp.queryForPendingCallsForHelp(HabboHelp.REPORT_TYPE_MESSAGE);
        }

        public function reportSelfie(k:String, _arg_2:String, _arg_3:Int, _arg_4:Int, _arg_5:Int)
        {
            this._habboHelp.sendMessage(new CallForHelpFromSelfieMessageComposer(k, _arg_3, _arg_4, _arg_2, _arg_5));
        }

        public function reportPhoto(k:String, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int)
        {
            this._habboHelp.setReportMessage(new CallForHelpFromPhotoMessageComposer(k, _arg_3, _arg_4, _arg_2, _arg_5));
            this._habboHelp.queryForPendingCallsForHelp(HabboHelp.REPORT_TYPE_PHOTO);
        }

        public function openEmergencyHelpRequest()
        {
            this.reportUser(0, HabboHelp.REPORT_TYPE_EMERGENCY, -1);
        }

        function showAbusiveNotice()
        {
            this.closeWindow();
            this._window = Std.downcast(this._habboHelp.getXmlWindow("abusive_notice") , IWindowContainer);
            this._window.center();
            this._window.findChildByName("header_button_close").visible = false;
            this._window.procedure = this.onAbusiveNoticeEvent;
        }

        public function showEmergencyHelpRequest(k:Int)
        {
            var _local_5:ISelectableWindow = null;
            var _local_6:ISelectableWindow = null;
            this.closeWindow();
            this._reportType = k;
            if (this._reportType == HabboHelp.REPORT_TYPE_BULLY)
            {
                this._window = Std.downcast(this._habboHelp.getXmlWindow("bully_report") , IWindowContainer);
                this._window.procedure = this.onBullyReportEvent;
            }
            else
            {
                this._window = Std.downcast(this._habboHelp.getXmlWindow("emergency_help_request") , IWindowContainer);
                this._window.procedure = this.onEmergencyHelpRequestEvent;
                cast(cast(this._window.findChildByName("help_message"), IWidgetWindow).widget, IIlluminaInputWidget).maxChars = FIELD_MAX_CHARS;
            }
            this._window.center();
            var _local_2= Std.downcast(this._window.findChildByName("user_panel") , IItemListWindow);
            var _local_3= Std.downcast(this._window.findChildByName("room_panel") , IItemListWindow);
            var _local_4= cast(this._window.findChildByName("topic_selector"), ISelectorWindow);
            if (_local_4 != null)
            {
                _local_5 = _local_4.getSelectableByName(("" + Std.string(this._incomingTopic)));
                if (_local_5 != null)
                {
                    _local_4.setSelected(_local_5);
                }
                _local_6 = _local_4.getSelectableByName("123");
                if (((!(_local_6 == null)) && this._habboHelp._Str_16486))
                {
                    _local_6.visible = false;
                }
            }
            switch (this._reportType)
            {
                case HabboHelp.REPORT_TYPE_ROOM:
                    this.showPanels(false, true);
                    return;
                case HabboHelp.REPORT_TYPE_EMERGENCY:
                    this.showPanels(true, false);
                    return;
                case HabboHelp.REPORT_TYPE_IM:
                    this.showPanels(false, false);
                    return;
                case HabboHelp.REPORT_TYPE_THREAD
                   | HabboHelp.REPORT_TYPE_MESSAGE:
                    this.showPanels(false, false);
                    return;
                case HabboHelp.REPORT_TYPE_BULLY:
                    this.populateUserList();
                    return;
            }
        }

        function showChatReportTool()
        {
            this.closeWindow();
            this._chatReportController.show(this._habboHelp._Str_6240, this._reportedUserId, this._reportType);
        }

        function showPanels(k:Bool, _arg_2:Bool)
        {
            var _local_3= Std.downcast(this._window.findChildByName("user_panel") , IItemListWindow);
            var _local_4= Std.downcast(this._window.findChildByName("room_panel") , IItemListWindow);
            var _local_5= (k || _arg_2);
            this._window.findChildByName("submit_box_wide").visible = _local_5;
            this._window.findChildByName("submit_box_narrow").visible = (!_local_5);
            this._window.findChildByName("separator").visible = _local_5;
            _local_4.visible = _arg_2;
            _local_3.visible = k;
            if (_arg_2)
            {
                _local_4.getListItemByName("room_name").caption = ((this._reportedRoomName != null) ? this._reportedRoomName : "");
                _local_4.getListItemByName("room_description").caption = ((this._reportedRoomDescription != null) ? this._reportedRoomDescription : "");
            }
            if (k)
            {
                this.populateUserList();
            }
            if (!_local_5)
            {
                this._window.width = 301;
            }
        }

        function populateUserList()
        {
            var _local_4:UserRegistryItem = null;
            var _local_5:IWindowContainer = null;
            var _local_6 = false;
            var k= Std.downcast(this._window.findChildByName("user_list") , IItemListWindow);
            var _local_2= Std.downcast(k.getListItemAt(0) , IWindowContainer);
            k.removeListItems();
            var _local_3 = 0;
            final _iter_ = this._habboHelp.userRegistry._Str_20328(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_4  = _tmp_;
                _local_5 = Std.downcast(_local_2.clone() , IWindowContainer);
                _local_6 = (_local_4.userId == this._reportedUserId);
                _local_5.name = Std.string(_local_4.userId);
                _local_5.blend = (_local_6 ? 1 : 0);
                _local_5.procedure = this.onUserSelectEvent;
                _local_5.findChildByName("user_name").caption = _local_4.userName;
                _local_5.findChildByName("room_name").id = _local_4.roomId;
                if (_local_6)
                {
                    this._reportedRoomId = _local_4.roomId;
                }
                _local_5.findChildByName("room_name").caption = ((_local_4.roomName != "") ? this._habboHelp.localization.getLocalizationWithParams("help.emergency.main.step.two.room.name", "", ["room_name", _local_4.roomName]) : "");
                cast(cast(_local_5.findChildByName("user_avatar"), IWidgetWindow).widget, IAvatarImageWidget).figure = _local_4.figure;
                k.addListItemAt(_local_5, _local_3);
                if (_local_6)
                {
                    _local_3 = 1;
                }
            }
        }

        function refreshUserList()
        {
            var _local_3:IWindowContainer = null;
            var k= Std.downcast(this._window.findChildByName("user_list") , IItemListWindow);
            var _local_2 = 0;
            while (_local_2 < k.numListItems)
            {
                _local_3 = cast(k.getListItemAt(_local_2), IWindowContainer);
                _local_3.blend = ((ASCompat.toInt(_local_3.name) == this._reportedUserId) ? 1 : 0);
                _local_2++;
            }
        }

        public function showPendingRequest(k:String)
        {
            this.closeWindow();
            this._window = Std.downcast(this._habboHelp.getXmlWindow("pending_request") , IWindowContainer);
            this._window.findChildByName("request_message").caption = k;
            this._window.center();
            this._window.procedure = this.onPendingReuqestEvent;
        }

        function closeWindow()
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        function onAbusiveNoticeEvent(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "close_button":
                        this.closeWindow();
                        return;
                }
            }
        }

        function onEmergencyHelpRequestEvent(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "submit_button":
                        if (!this.saveEmergencyHelpRequestData())
                        {
                            return;
                        }
                        this.basicInfoDone();
                        return;
                    case "header_button_close":
                        this.closeWindow();
                        return;
                }
            }
        }

        function onBullyReportEvent(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "submit_button":
                        if (this._reportedUserId > 0)
                        {
                            this._habboHelp.sendMessage(new IgnoreUserIdMessageComposer(this._reportedUserId));
                            this._habboHelp.sendMessage(new ChatReviewSessionCreateMessageComposer(this._reportedUserId, this._reportedRoomId));
                            this.closeWindow();
                        }
                        else
                        {
                            this._habboHelp.windowManager.alert("${generic.alert.title}", "${guide.bully.request.usermissing}", 0, null);
                        }
                        return;
                    case "header_button_close":
                        this.closeWindow();
                        return;
                }
            }
        }

        function onChatReportEvent(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "submit_button":
                        if (this._chatReportController.collectSelectedEntries(this._reportType, -1).length == 0)
                        {
                            this._habboHelp.windowManager.alert("${generic.alert.title}", "${help.cfh.error.chatmissing}", 0, null);
                            return;
                        }
                        this.submitCallForHelp();
                        this._chatReportController.closeWindow();
                        this.closeWindow();
                        return;
                    case "header_button_close":
                        this._chatReportController.closeWindow();
                        return;
                }
            }
        }

        function onUserSelectEvent(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this.selectUserToReport(Std.downcast(_arg_2 , IWindowContainer));
            }
        }

        function selectUserToReport(k:IWindowContainer)
        {
            if ((((this._window == null) || (!(this._window.name == EMERGENCY_HELP_REQUEST))) || (k == null)))
            {
                return;
            }
            var _local_2= ASCompat.toInt(k.name);
            if (this._reportedUserId == _local_2)
            {
                this._reportedUserId = 0;
                this._reportedRoomId = -1;
            }
            else
            {
                this._reportedUserId = _local_2;
                this._reportedRoomId = k.findChildByName("room_name").id;
            }
            this.refreshUserList();
        }

        function basicInfoDone()
        {
            var k= this.isChatSelectionRequired();
            if (this._reportType == HabboHelp.REPORT_TYPE_IM)
            {
                if (!this._habboHelp.instantMessageRegistry._Str_23839(this._reportedUserId))
                {
                    this._habboHelp.windowManager.alert("${generic.alert.title}", "${help.cfh.error.nochathistory}", 0, null);
                }
            }
            else
            {
                if (((k && (!this._habboHelp.chatRegistry._Str_20222(this._habboHelp._Str_6240))) && this._habboHelp.chatRegistry._Str_20222(this._reportedUserId)))
                {
                    this._habboHelp.windowManager.alert("${generic.alert.title}", "${help.cfh.error.nochathistory}", 0, null);
                    return;
                }
            }
            if (k)
            {
                this.showChatReportTool();
            }
            else
            {
                this.submitCallForHelp();
            }
        }

        function isChatSelectionRequired():Bool
        {
            if ((((this._reportType == HabboHelp.REPORT_TYPE_THREAD) || (this._reportType == HabboHelp.REPORT_TYPE_MESSAGE)) || (this._reportType == HabboHelp.REPORT_TYPE_ROOM)))
            {
                return false;
            }
            return ((this._reportedUserId <= 0) || (this._habboHelp.chatRegistry.getItemsByUser(this._reportedUserId).length > 0)) || (this._reportType == HabboHelp.REPORT_TYPE_IM);
        }

        function saveEmergencyHelpRequestData(k:Bool=true):Bool
        {
            if (((this._window == null) || (!(this._window.name == EMERGENCY_HELP_REQUEST))))
            {
                return false;
            }
            this._message = cast(cast(this._window.findChildByName("help_message"), IWidgetWindow).widget, IIlluminaInputWidget).message;
            if (((this._message == null) || (this._message == "")))
            {
                this._habboHelp.windowManager.alert("${generic.alert.title}", "${help.cfh.error.nomsg}", 0, null);
                return false;
            }
            if (this._message.length < this._habboHelp.getInteger("help.cfh.length.minimum", 15))
            {
                this._habboHelp.windowManager.alert("${generic.alert.title}", "${help.cfh.error.msgtooshort}", 0, null);
                return false;
            }
            this._topicIndex = 0;
            var _local_2= cast(this._window.findChildByName("topic_selector"), ISelectorWindow).getSelected();
            if (_local_2 != null)
            {
                this._topicIndex = ASCompat.toInt(_local_2.name);
            }
            if (this._topicIndex == 0)
            {
                this._habboHelp.windowManager.alert("${generic.alert.title}", "${help.cfh.error.notopic}", 0, null);
                return false;
            }
            if (((this._reportType == HabboHelp.REPORT_TYPE_MESSAGE) || (this._reportType == HabboHelp.REPORT_TYPE_THREAD)))
            {
                return true;
            }
            if ((((this._reportedUserId <= 0) && ((!(this._reportType == HabboHelp.REPORT_TYPE_MESSAGE)) && (this._reportType == HabboHelp.REPORT_TYPE_THREAD))) || ((this._reportType == HabboHelp.REPORT_TYPE_ROOM) && (!this._habboHelp.getBoolean("room.report.enabled")))))
            {
                this._habboHelp.windowManager.alert("${generic.alert.title}", "${guide.bully.request.usermissing}", 0, null);
                return false;
            }
            if (this._habboHelp.friendList.getFriend(this._reportedUserId) != null)
            {
                this._habboHelp.windowManager.confirm("${help.cfh.unfriend.confirm.title}", "${help.cfh.unfriend.confirm.message}", (HabboAlertDialogFlag.BUTTON_OK | HabboAlertDialogFlag.BUTTON_CANCEL), this.onFriendReportConfirmation);
                return false;
            }
            return true;
        }

        function submitCallForHelp()
        {
            var k = 0;
            this.closeWindow();
            switch (this._reportType)
            {
                case HabboHelp.REPORT_TYPE_EMERGENCY
                   | HabboHelp.REPORT_TYPE_ROOM:
                    k = ((this._chatReportController._Str_3469 <= 0) ? this._reportedRoomId : this._chatReportController._Str_3469);
                    this._habboHelp.sendMessage(new CallForHelpMessageComposer(this._message, this._topicIndex, this._reportedUserId, k, this._chatReportController.collectSelectedEntries(this._reportType, -1)));
                    
                case HabboHelp.REPORT_TYPE_IM:
                    this._habboHelp.sendMessage(new CallForHelpFromIMMessageComposer(this._message, this._topicIndex, this._reportedUserId, this._chatReportController.collectSelectedEntries(HabboHelp.REPORT_TYPE_IM, -1)));
                    
                case HabboHelp.REPORT_TYPE_THREAD:
                    this._habboHelp.sendMessage(new CallForHelpFromForumThreadMessageComposer(this._reportedGroupId, this._reportedThreadId, this._topicIndex, this._message));
                    
                case HabboHelp.REPORT_TYPE_MESSAGE:
                    this._habboHelp.sendMessage(new CallForHelpFromForumMessageMessageComposer(this._reportedGroupId, this._reportedThreadId, this._reportedMessageId, this._topicIndex, this._message));
                    
            }
            this._habboHelp.ignoreAndUnfriendReportedUser();
        }

        function onFriendReportConfirmation(k:IAlertDialog, _arg_2:WindowEvent)
        {
            if (_arg_2.type == WindowEvent.WINDOW_EVENT_OK)
            {
                this.basicInfoDone();
            }
            k.dispose();
        }

        function onPendingReuqestEvent(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "keep_button"
                       | "header_button_close":
                        this.closeWindow();
                        return;
                    case "discard_button":
                        this.deletePendingCallsForHelp();
                        this.closeWindow();
                        return;
                }
            }
        }

        function onCallForHelpReply(k:IMessageEvent)
        {
            var _local_2= cast(k, CallForHelpReplyMessageEvent).getParser();
            this._habboHelp.windowManager.alert("${help.cfh.reply.title}", _local_2.message, 0, null);
        }

        function onCallForHelpResult(k:IMessageEvent)
        {
            var _local_2= cast(k, CallForHelpResultMessageEvent).getParser();
            var _local_3= _local_2.resultType;
            var _local_4= _local_2.messageText;
            switch (_local_3)
            {
                case CallForHelpResultEnum.TOO_MANY_PENDING_CALLS_CODE:
                    this._habboHelp.queryForPendingCallsForHelp(HabboHelp.REPORT_TYPE_EMERGENCY);
                    return;
                case CallForHelpResultEnum.HAS_ABUSIVE_CALL_CODE:
                    this.showAbusiveNotice();
                    return;
                default:
                    if (_local_4 == "")
                    {
                        _local_4 = "${help.cfh.sent.text}";
                    }
                    this._habboHelp.windowManager.alert("${help.cfh.sent.title}", _local_4, 0, null);
            }
        }

        function onIssueClose(k:IssueCloseNotificationMessageEvent)
        {
            var _local_2= k.getParser();
            var _local_3= _local_2.messageText;
            if (_local_3 == "")
            {
                _local_3 = (("${help.cfh.closed." + getCloseReasonKey(_local_2._Str_25784)) + "}");
            }
            this._habboHelp.windowManager.alert("${mod.alert.title}", _local_3, 0, null);
        }

        function deletePendingCallsForHelp()
        {
            this._habboHelp.sendMessage(new DeletePendingCallsForHelpMessageComposer());
        }

        public var chatReportController(get,never):ChatReportController;
public function  get_chatReportController():ChatReportController
        {
            return this._chatReportController;
        }
    }

