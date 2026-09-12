package com.sulake.habbo.help
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.window.utils.IModalDialog;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.communication.messages.incoming.callforhelp.CallForHelpTopicData;
    import com.sulake.habbo.window.widgets.IIlluminaInputWidget;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.help._enum._Str_2849;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.outgoing.help.CallForHelpFromPhotoMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.help.CallForHelpFromIMMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.help.CallForHelpMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.help.CallForHelpFromForumThreadMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.help.CallForHelpFromForumMessageMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.help.ChatReviewSessionCreateMessageComposer;
    import com.sulake.habbo.help.cfh.registry.user.UserRegistryItem;
    import com.sulake.habbo.help.cfh.registry.chat.ChatRegistryItem;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.habbo.communication.messages.incoming.callforhelp.CallForHelpCategoryData;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.ITextLinkWindow;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.habbo.help.cfh.registry.instantmessage.InstantMessageRegistryItem;

     class TopicsFlowHelpController implements IDisposable 
    {
        static inline final START_CONTAINER= "start_container";
        static inline final HELP_CONTAINER= "help_container";
        static inline final USERS_CONTAINER= "users_container";
        static inline final USER= "user";
        static inline final REASON_CONTAINER= "reason_container";
        static inline final TOPIC_CONTAINER= "topic_container";
        static inline final MESSAGE_CONTAINER= "message_container";
        static inline final CHAT_CONTAINER= "chat_container";
        static inline final BACK_BUTTON= "back_button";
        static inline final SUMMARY_CONTAINER= "summary_container";
        static inline final CONTINUE_BUTTON= "continue_button";
        static final _Str_19021:Array<ASAny> = [USERS_CONTAINER, MESSAGE_CONTAINER, CHAT_CONTAINER];
        static final _Str_14416:Array<ASAny> = [REASON_CONTAINER, MESSAGE_CONTAINER, CHAT_CONTAINER, SUMMARY_CONTAINER];
        static inline final FIELD_MAX_CHARS= 253;
        static inline final BULLYING= "bullying";
        static inline final HABBO_NAME= "habbo_name";

        var _habboHelp:HabboHelp;
        var _disposed:Bool = false;
        var _helpDialog:IModalDialog;
        var _view:IWindowContainer;
        var _containers:Vector<String>;
        var _usersList:IItemListWindow;
        var _reasonsList:IItemListWindow;
        var _chatList:IItemListWindow;
        var _userPrototype:IWindowContainer;
        var _reasonPrototype:IWindowContainer;
        var _chatPrototype:IWindowContainer;
        var _currentContainer:String = "start_container";
        var _currentTopic:CallForHelpTopicData;
        var _message:String;
        var _reportedUserName:String;
        var _contentModerationType:Int = -1;
        var _userNameReporting:Bool = false;

        public function new(k:HabboHelp)
        {
            this._habboHelp = k;
            this._containers = new Vector<String>(0);
            ASCompat.ASArray.pushMultiple(this._containers, START_CONTAINER, HELP_CONTAINER, USERS_CONTAINER, USER, REASON_CONTAINER, MESSAGE_CONTAINER, CHAT_CONTAINER, BACK_BUTTON, SUMMARY_CONTAINER);
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this.closeWindow();
            this._habboHelp = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function _Str_24232()
        {
            this._userNameReporting = true;
            this._Str_13370(-1, false);
            this._currentTopic = this._Str_21261(HABBO_NAME);
            this._view.findChildByName("message_phase_title").caption = ((this._habboHelp.localization.getLocalization("generic.reason") + " ") + this._habboHelp.localization.getLocalization(("help.cfh.topic." + Std.string(this._currentTopic.id))));
            this.showContainer(MESSAGE_CONTAINER);
        }

        public function _Str_25197()
        {
            this._Str_13370(-1, true);
            if (!this._Str_25232())
            {
                return;
            }
            this.showContainer(CHAT_CONTAINER);
            this._Str_22227();
        }

        public function _Str_15173(k:Int):Bool
        {
            this._Str_13370(k, false);
            var _local_2= this._Str_24500();
            if (!_local_2)
            {
                this.closeWindow();
            }
            return _local_2;
        }

        public function _Str_23015()
        {
            this._Str_13370(HabboHelp.REPORT_TYPE_IM, false);
            this.showContainer(CHAT_CONTAINER);
            this._Str_23695();
            if (this._chatList.numListItems == 0)
            {
                this._habboHelp.windowManager.alertWithModal("${generic.alert.title}", "${help.cfh.error.no_user_data}", 0, null);
                this.closeWindow();
            }
        }

        function _Str_13370(k:Int, _arg_2:Bool)
        {
            this._contentModerationType = k;
            if (this._helpDialog == null)
            {
                this.openWindow();
            }
            this._view.findChildByName("change_user").visible = _arg_2;
        }

        function openWindow()
        {
            if (((this._helpDialog == null) && (!this.disposed)))
            {
                this._helpDialog = this._habboHelp.getModalXmlWindow("topics_flow_help");
                this._helpDialog.rootWindow.procedure = this._Str_18394;
                this._view = Std.downcast(this._helpDialog.rootWindow , IWindowContainer);
                this._usersList = Std.downcast(this._view.findChildByName("user_list") , IItemListWindow);
                this._reasonsList = Std.downcast(this._view.findChildByName("reason_list") , IItemListWindow);
                this._chatList = Std.downcast(this._view.findChildByName("chat_list") , IItemListWindow);
                this._userPrototype = Std.downcast(this._usersList.getListItemAt(0) , IWindowContainer);
                this._reasonPrototype = Std.downcast(this._reasonsList.getListItemAt(0) , IWindowContainer);
                this._chatPrototype = Std.downcast(this._chatList.getListItemAt(0) , IWindowContainer);
                this._usersList.removeListItems();
                this._reasonsList.removeListItems();
                this._chatList.removeListItems();
                cast(cast(this._view.findChildByName("help_message"), IWidgetWindow).widget, IIlluminaInputWidget).maxChars = FIELD_MAX_CHARS;
                this._Str_14598();
            }
        }

        public function closeWindow()
        {
            if (this._helpDialog != null)
            {
                this._helpDialog.dispose();
                this._helpDialog = null;
            }
            this._currentContainer = START_CONTAINER;
        }

        public function toggleWindow()
        {
            if (this._helpDialog == null)
            {
                this._contentModerationType = -1;
                this.openWindow();
                this.showContainer(START_CONTAINER);
            }
            else
            {
                this.closeWindow();
            }
        }

        function showContainer(k:String)
        {
            var _local_2:String = null;
            final _iter_ = this._containers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                this._view.findChildByName(_local_2).visible = false;
            }
            this._view.findChildByName(CONTINUE_BUTTON).visible = (_Str_19021.indexOf(k) > -1);
            this._view.findChildByName(USER).visible = (_Str_14416.indexOf(k) > -1);
            this._currentContainer = k;
            this._Str_21276();
            this._view.findChildByName(k).visible = true;
            if (_Str_14416.indexOf(k) > -1)
            {
                this._Str_17133();
            }
        }

        function _Str_21276()
        {
            var k= true;
            if (this._currentContainer == START_CONTAINER)
            {
                k = false;
            }
            else
            {
                if (this._contentModerationType == HabboHelp.REPORT_TYPE_IM)
                {
                    k = (!(this._currentContainer == CHAT_CONTAINER));
                }
                else
                {
                    if ((this._contentModerationType > -1))
                    {
                        k = (!(this._currentContainer == REASON_CONTAINER));
                    }
                    else
                    {
                        if (this._userNameReporting)
                        {
                            k = (!(this._currentContainer == MESSAGE_CONTAINER));
                        }
                    }
                }
            }
            this._view.findChildByName(BACK_BUTTON).visible = k;
        }

        function _Str_19840():Bool
        {
            if (this._habboHelp.reportedUserId == -1)
            {
                this._habboHelp.windowManager.alertWithModal("${generic.alert.title}", "${guide.bully.request.usermissing}", 0, null);
                return false;
            }
            return true;
        }

        function _Str_25494():Bool
        {
            this._message = cast(cast(this._view.findChildByName("help_message"), IWidgetWindow).widget, IIlluminaInputWidget).message;
            if (((this._message == null) || (this._message == "")))
            {
                this._habboHelp.windowManager.alertWithModal("${generic.alert.title}", "${help.cfh.error.nomsg}", 0, null);
                return false;
            }
            if (this._message.length < this._habboHelp.getInteger("help.cfh.length.minimum", 15))
            {
                this._habboHelp.windowManager.alertWithModal("${generic.alert.title}", "${help.cfh.error.msgtooshort}", 0, null);
                return false;
            }
            return true;
        }

        function _Str_23993():Bool
        {
            var k= this._habboHelp.callForHelpManager.chatReportController.collectSelectedEntries(this._contentModerationType, this._habboHelp.reportedUserId);
            if (((k == null) || (k.length == 0)))
            {
                this._habboHelp.windowManager.alertWithModal("${generic.alert.title}", "${help.cfh.error.chatmissing}", 0, null);
                return false;
            }
            return true;
        }

        function _Str_18394(k:WindowEvent, _arg_2:IWindow)
        {
            if ((this.disposed || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "header_button_close":
                    this.closeWindow();
                    return;
                case BACK_BUTTON:
                    switch (this._currentContainer)
                    {
                        case REASON_CONTAINER:
                            this.showContainer(CHAT_CONTAINER);
                            
                        case TOPIC_CONTAINER
                           | MESSAGE_CONTAINER:
                            this.showContainer(REASON_CONTAINER);
                            this._Str_18243();
                            
                        case CHAT_CONTAINER:
                            if (this._Str_16001())
                            {
                                this.showContainer(USERS_CONTAINER);
                            }
                            else
                            {
                                this.showContainer(START_CONTAINER);
                            }
                            
                        case SUMMARY_CONTAINER:
                            this.showContainer(MESSAGE_CONTAINER);
                            
                        default:
                            this.showContainer(START_CONTAINER);
                    }
                    return;
                case "continue_button":
                    switch (this._currentContainer)
                    {
                        case USERS_CONTAINER:
                            if (this._Str_19840())
                            {
                                this.showContainer(CHAT_CONTAINER);
                                this._Str_22227();
                            }
                            
                        case MESSAGE_CONTAINER:
                            if (this._Str_25494())
                            {
                                this.showContainer(SUMMARY_CONTAINER);
                            }
                            
                        case CHAT_CONTAINER:
                            if (this._Str_23993())
                            {
                                this.showContainer(REASON_CONTAINER);
                                this._Str_18243();
                            }
                            
                        default:
                            this.showContainer(START_CONTAINER);
                    }
                    return;
                case "button_habbo_help":
                    this.showContainer(HELP_CONTAINER);
                    return;
                case "button_user_report"
                   | "change_user":
                    if (this._Str_16001())
                    {
                        this.showContainer(USERS_CONTAINER);
                    }
                    else
                    {
                        this._habboHelp.windowManager.alertWithModal("${generic.alert.title}", "${help.cfh.error.nochathistory}", 0, null);
                    }
                    return;
                case "button_account":
                    HabboWebTools.openWebPage(this._habboHelp.getProperty("zendesk.url"), "habboMain");
                    this._habboHelp.trackGoogle("helpWindow", "click_selfHelp");
                    this.closeWindow();
                    return;
                case "tour_button":
                    this._habboHelp._Str_21711.createHelpRequest((this._habboHelp.newIdentity ? _Str_2849._Str_4268 : _Str_2849._Str_4749));
                    this._habboHelp.trackGoogle("helpWindow", "click_userTour");
                    this.closeWindow();
                    return;
                case "bully_button":
                    this.closeWindow();
                    this._habboHelp.toggleNewHelpWindow();
                    this._habboHelp.trackGoogle("helpWindow", "click_reportBully");
                    return;
                case "instructions_button":
                    this._habboHelp._Str_21711.createHelpRequest(_Str_2849._Str_7052);
                    this._habboHelp.trackGoogle("helpWindow", "click_instructions");
                    this.closeWindow();
                    return;
                case "safetybooklet_link":
                    this._habboHelp.showSafetyBooklet();
                    this._habboHelp.trackGoogle("helpWindow", "click_showSafetyBooklet");
                    this.closeWindow();
                    return;
                case "habboway_link":
                    if (this._habboHelp.getBoolean("habboway.enabled"))
                    {
                        this._habboHelp.showHabboWay();
                    }
                    else
                    {
                        HabboWebTools.openWebPage(this._habboHelp.getProperty("habboway.url"), "habboMain");
                    }
                    this._habboHelp.trackGoogle("helpWindow", "click_habboWay");
                    this.closeWindow();
                    return;
                case "faq_link":
                    this._habboHelp.openCfhFaq();
                    return;
                case "sanction_info_link":
                    this._habboHelp.requestSanctionInfo(false);
                    this.closeWindow();
                    return;
                case "submit_button":
                    if (this._currentTopic != null)
                    {
                        this.submitCallForHelp(true);
                        this.closeWindow();
                    }
                    else
                    {
                        this._habboHelp.windowManager.alertWithModal("${generic.alert.title}", "${help.cfh.error.notopic}", 0, null);
                    }
                    return;
            }
        }

        public function submitCallForHelp(k:Bool)
        {
            if ((((!ASCompat.stringAsBool(this._message)) || (!(this._currentTopic != null))) || (!(this._habboHelp != null))))
            {
                return;
            }
            this._habboHelp.ignoreAndUnfriendReportedUser();
            switch (this._contentModerationType)
            {
                case HabboHelp.REPORT_TYPE_PHOTO:
                    this._habboHelp.sendMessage(new CallForHelpFromPhotoMessageComposer(this._habboHelp._Str_11455, this._habboHelp._Str_3469, this._habboHelp.reportedUserId, this._currentTopic.id, this._habboHelp._Str_10658));
                    return;
                case HabboHelp.REPORT_TYPE_IM:
                    this._habboHelp.sendMessage(new CallForHelpFromIMMessageComposer(this._message, this._currentTopic.id, this._habboHelp.reportedUserId, this._habboHelp.callForHelpManager.chatReportController.collectSelectedEntries(HabboHelp.REPORT_TYPE_IM, this._habboHelp.reportedUserId)));
                    return;
                case HabboHelp.REPORT_TYPE_ROOM:
                    this._habboHelp.sendMessage(new CallForHelpMessageComposer(this._message, this._currentTopic.id, -1, this._habboHelp._Str_3469, []));
                    return;
                case HabboHelp.REPORT_TYPE_THREAD:
                    this._habboHelp.sendMessage(new CallForHelpFromForumThreadMessageComposer(this._habboHelp.callForHelpManager._Str_11420, this._habboHelp.callForHelpManager._Str_10392, this._currentTopic.id, this._message));
                    return;
                case HabboHelp.REPORT_TYPE_MESSAGE:
                    this._habboHelp.sendMessage(new CallForHelpFromForumMessageMessageComposer(this._habboHelp.callForHelpManager._Str_11420, this._habboHelp.callForHelpManager._Str_10392, this._habboHelp.callForHelpManager._Str_16155, this._currentTopic.id, this._message));
                    return;
                default:
                    if ((((k && (this._currentTopic.name == BULLYING)) && this._habboHelp.getBoolean("guides.enabled")) && this._habboHelp._Str_16486))
                    {
                        this._habboHelp.sendMessage(new ChatReviewSessionCreateMessageComposer(this._habboHelp.reportedUserId, this._habboHelp._Str_3469));
                    }
                    else
                    {
                        this._habboHelp.sendMessage(new CallForHelpMessageComposer(this._message, this._currentTopic.id, this._habboHelp.reportedUserId, this._habboHelp._Str_3469, this._habboHelp.callForHelpManager.chatReportController.collectSelectedEntries(HabboHelp.REPORT_TYPE_EMERGENCY, -1)));
                    }
            }
        }

        function _Str_16001():Bool
        {
            var _local_3:UserRegistryItem = null;
            var _local_4:Vector<ChatRegistryItem> = null;
            var _local_5:IWindowContainer = null;
            var _local_6 = false;
            this._usersList.removeListItems();
            var k = 0;
            var _local_2 = false;
            final _iter_ = this._habboHelp.userRegistry._Str_20328(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
_local_3  = _tmp_;
                _local_4 = this._habboHelp.chatRegistry.getItemsByUser(_local_3.userId);
                if (_local_4.length == 0)
                {
                }
                else
                {
                    _local_5 = Std.downcast(this._userPrototype.clone() , IWindowContainer);
                    _local_6 = (_local_3.userId == this._habboHelp.reportedUserId);
                    _local_5.name = Std.string(_local_3.userId);
                    _local_5.findChildByName("user_bg").blend = (_local_6 ? 1 : 0);
                    _local_5.procedure = this.onUserSelectEvent;
                    _local_5.findChildByName("user_name").caption = _local_3.userName;
                    _local_5.findChildByName("room_name").id = _local_3.roomId;
                    if (_local_6)
                    {
                        this._habboHelp._Str_3469 = _local_3.roomId;
                    }
                    _local_5.findChildByName("room_name").caption = ((_local_3.roomName != "") ? this._habboHelp.localization.getLocalizationWithParams("help.emergency.main.step.two.room.name", "", ["room_name", _local_3.roomName]) : "");
                    cast(cast(_local_5.findChildByName("user_avatar"), IWidgetWindow).widget, IAvatarImageWidget).figure = _local_3.figure;
                    this._usersList.addListItemAt(_local_5, k);
                    if (_local_6)
                    {
                        k = 1;
                        _local_2 = true;
                    }
                }
            }
            if (!_local_2)
            {
                this._habboHelp.reportedUserId = -1;
                this._habboHelp._Str_3469 = -1;
            }
            return this._usersList.numListItems > 0;
        }

        function refreshUserList()
        {
            var _local_2:IWindowContainer = null;
            var k = 0;
            while (k < this._usersList.numListItems)
            {
                _local_2 = cast(this._usersList.getListItemAt(k), IWindowContainer);
                _local_2.findChildByName("user_bg").blend = ((ASCompat.toInt(_local_2.name) == this._habboHelp.reportedUserId) ? 1 : 0);
                k++;
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
            var _local_2= ASCompat.toInt(k.name);
            this._habboHelp.reportedUserId = _local_2;
            this._habboHelp._Str_3469 = k.findChildByName("room_name").id;
            this.refreshUserList();
        }

        function _Str_18243()
        {
            var k:CallForHelpCategoryData = null;
            var _local_2:IWindowContainer = null;
            this._reasonsList.destroyListItems();
            final _iter_ = this._habboHelp.callForHelpCategories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = _tmp_;
                _local_2 = Std.downcast(this._reasonPrototype.clone() , IWindowContainer);
                _local_2.findChildByName("name").caption = (("${help.cfh.reason." + k.name) + "}");
                _local_2.name = k.name;
                _local_2.addEventListener(WindowMouseEvent.CLICK, this._Str_24412);
                this._reasonsList.addListItem(_local_2);
            }
        }

        function _Str_24412(k:WindowEvent)
        {
            var _local_2= k.target;
            this._Str_23777(_local_2.name);
        }

        function _Str_23777(k:String):Bool
        {
            var _local_2:Vector<CallForHelpTopicData> = null;
            var _local_3:CallForHelpCategoryData = null;
            var _local_4 = 0;
            var _local_5:CallForHelpTopicData = null;
            var _local_6:IWindowContainer = null;
            var _local_7:ITextWindow = null;
            final _iter_ = this._habboHelp.callForHelpCategories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (_local_3.name == k)
                {
                    _local_2 = _local_3._Str_14841;
                    break;
                }
            }
            if (((_local_2 != null) && (_local_2.length > 0)))
            {
                this._reasonsList.destroyListItems();
                _local_4 = this._reasonsList.height;
                this._reasonsList.height = 0;
                this._reasonsList.height = _local_4;
                if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
                {
_local_5  = _tmp_;
                    _local_6 = Std.downcast(this._reasonPrototype.clone() , IWindowContainer);
                    this._habboHelp.localization.registerParameter(("help.cfh.topic." + Std.string(_local_5.id)), "name", this._reportedUserName);
                    _local_7 = Std.downcast(_local_6.findChildByName("name") , ITextWindow);
                    _local_7.caption = (("${help.cfh.topic." + Std.string(_local_5.id)) + "}");
                    if (_local_7.height < _local_7.textHeight)
                    {
                        _local_7.height = Std.int(_local_7.textHeight + 5);
                    }
                    if (_local_6.height < ((_local_7.height + (_local_7.y * 2)) + 5))
                    {
                        _local_6.height = ((_local_7.height + (_local_7.y * 2)) + 5);
                    }
                    _local_6.name = _local_5.name;
                    _local_6.addEventListener(WindowMouseEvent.CLICK, this._Str_24731);
                    this._reasonsList.addListItem(_local_6);
                }
                this._currentContainer = TOPIC_CONTAINER;
                this._Str_21276();
            }
            else
            {
                return false;
            }
            return true;
        }

        function _Str_22227()
        {
            var _local_2:ChatRegistryItem = null;
            var _local_3:IWindowContainer = null;
            var _local_4:ITextLinkWindow = null;
            var _local_5:ICheckBoxWindow = null;
            this._chatList.removeListItems();
            this._habboHelp.chatRegistry._Str_7724 = true;
            var k= ((this._habboHelp.reportedUserId > 0) ? this._habboHelp.chatRegistry.getItemsByUser(this._habboHelp.reportedUserId) : this._habboHelp.chatRegistry._Str_6828());
            Logger.log([((("Found chat items: " + Std.string(k.length)) + " from user:") + Std.string(this._habboHelp.reportedUserId))]);
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                if (_local_2.userId == this._habboHelp._Str_6240)
                {
                }
                else
                {
                    _local_3 = Std.downcast(this._chatPrototype.clone() , IWindowContainer);
                    _local_4 = Std.downcast(_local_3.findChildByName("chat_text") , ITextLinkWindow);
                    _local_4.caption = _local_2.text;
                    if (_local_4.height < _local_4.textHeight)
                    {
                        _local_4.height = Std.int(_local_4.textHeight + 5);
                    }
                    if (_local_3.height < (_local_4.height + (_local_4.y * 2)))
                    {
                        _local_3.height = (_local_4.height + (_local_4.y * 2));
                    }
                    _local_3.id = _local_2.index;
                    _local_3.procedure = this._Str_18834;
                    _local_5 = Std.downcast(_local_3.findChildByName("chat_check") , ICheckBoxWindow);
                    _local_5.Selected = _local_2.selected;
                    this._chatList.addListItem(_local_3);
                }
            }
        }

        function _Str_14598()
        {
            var k:Vector<InstantMessageRegistryItem> = null;
            var _local_2:ChatRegistryItem = null;
            var _local_3:InstantMessageRegistryItem = null;
            final _iter_ = this._habboHelp.instantMessageRegistry._Str_6828(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
k  = _tmp_;
                if (checkNullIteratee(k)) for (_tmp_ in k)
                {
_local_3  = _tmp_;
                    _local_3.selected = false;
                }
            }
            final _iter_ = this._habboHelp.chatRegistry._Str_6828(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_2.selected = false;
            }
        }

        function _Str_18834(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = 0;
            var _local_4:ICheckBoxWindow = null;
            var _local_5:ChatRegistryItem = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                _local_3 = _arg_2.id;
                if (Std.is(_arg_2 , ITextLinkWindow))
                {
                    _local_3 = _arg_2.parent.id;
                    _local_4 = Std.downcast(Std.downcast(_arg_2.parent , IWindowContainer).findChildByName("chat_check") , ICheckBoxWindow);
                }
                if (Std.is(_arg_2 , ICheckBoxWindow))
                {
                    _local_3 = _arg_2.parent.id;
                    _local_4 = Std.downcast(_arg_2 , ICheckBoxWindow);
                }
                _local_5 = this._habboHelp.chatRegistry.getItem(_local_3);
                if (_local_5 == null)
                {
                    return;
                }
                if (((!_local_5.selected) && (!(_local_5.roomId == this._habboHelp._Str_3469))))
                {
                    this._habboHelp._Str_3469 = _local_5.roomId;
                }
                _local_5.selected = (!_local_5.selected);
                _local_4.Selected = _local_5.selected;
            }
        }

        function _Str_23695()
        {
            var _local_2:InstantMessageRegistryItem = null;
            var _local_3:IWindowContainer = null;
            var _local_4:ICheckBoxWindow = null;
            this._chatList.removeListItems();
            this._habboHelp.instantMessageRegistry._Str_7724 = true;
            var k= this._habboHelp.instantMessageRegistry.getItemsByUser(this._habboHelp.reportedUserId);
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                _local_3 = Std.downcast(this._chatPrototype.clone() , IWindowContainer);
                _local_3.findChildByName("chat_text").caption = _local_2.text;
                _local_3.id = _local_2.index;
                _local_3.procedure = this._Str_17227;
                _local_4 = Std.downcast(_local_3.findChildByName("chat_check") , ICheckBoxWindow);
                _local_4.Selected = _local_2.selected;
                this._chatList.addListItem(_local_3);
            }
        }

        function _Str_17227(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = 0;
            var _local_4:ICheckBoxWindow = null;
            var _local_5:InstantMessageRegistryItem = null;
            if (k.type == WindowMouseEvent.CLICK)
            {
                _local_3 = _arg_2.id;
                if (Std.is(_arg_2 , ITextLinkWindow))
                {
                    _local_3 = _arg_2.parent.id;
                    _local_4 = Std.downcast(Std.downcast(_arg_2.parent , IWindowContainer).findChildByName("chat_check") , ICheckBoxWindow);
                }
                else
                {
                    if (Std.is(_arg_2 , ICheckBoxWindow))
                    {
                        _local_3 = _arg_2.parent.id;
                        _local_4 = Std.downcast(_arg_2 , ICheckBoxWindow);
                    }
                }
                _local_5 = this._habboHelp.instantMessageRegistry.getItem(this._habboHelp.reportedUserId, _local_3);
                if (_local_5 != null)
                {
                    _local_5.selected = (!_local_5.selected);
                    _local_4.Selected = _local_5.selected;
                }
            }
        }

        function _Str_24731(k:WindowEvent=null)
        {
            if (this._helpDialog == null)
            {
                this.openWindow();
            }
            this._currentTopic = this._Str_21261(k.target.name);
            this.showContainer(MESSAGE_CONTAINER);
        }

        function _Str_24715():Bool
        {
            return ((this._contentModerationType == HabboHelp.REPORT_TYPE_ROOM) || (this._contentModerationType == HabboHelp.REPORT_TYPE_THREAD)) || (this._contentModerationType == HabboHelp.REPORT_TYPE_MESSAGE);
        }

        function _Str_24500():Bool
        {
            if ((this._Str_24715() || this._Str_19840()))
            {
                this.showContainer(REASON_CONTAINER);
                this._Str_18243();
                return true;
            }
            return false;
        }

        function _Str_25232():Bool
        {
            this._Str_16001();
            if (this._habboHelp.reportedUserId <= 0)
            {
                this._habboHelp.windowManager.alertWithModal("${generic.alert.title}", "${help.cfh.error.no_user_data}", 0, null);
                this.closeWindow();
                return false;
            }
            return true;
        }

        function _Str_21261(k:String):CallForHelpTopicData
        {
            var _local_2:CallForHelpCategoryData = null;
            var _local_3:CallForHelpTopicData = null;
            final _iter_ = this._habboHelp.callForHelpCategories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                final _iter_ = _local_2._Str_14841; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_3  = _tmp_;
                    if (_local_3.name == k)
                    {
                        return _local_3;
                    }
                }
            }
            return null;
        }

        function _Str_17133()
        {
            var k:UserRegistryItem = null;
            switch (this._contentModerationType)
            {
                case HabboHelp.REPORT_TYPE_ROOM:
                    this._view.findChildByName("reported_user_avatar").visible = false;
                    this._view.findChildByName("user_info_title").visible = false;
                    this._view.findChildByName("reported_user_name").caption = this._habboHelp.callForHelpManager._Str_16366;
                    return;
                case HabboHelp.REPORT_TYPE_THREAD
                   | HabboHelp.REPORT_TYPE_MESSAGE:
                    this._view.findChildByName("reported_user_avatar").visible = false;
                    this._view.findChildByName("user_info_title").visible = false;
                    this._view.findChildByName("reported_user_name").visible = false;
                    return;
                default:
                    if (this._habboHelp.reportedUserId > 0)
                    {
                        k = this._habboHelp.userRegistry.getEntry(this._habboHelp.reportedUserId);
                        if (k != null)
                        {
                            this._reportedUserName = k.userName;
                            cast(cast(this._view.findChildByName("reported_user_avatar"), IWidgetWindow).widget, IAvatarImageWidget).figure = k.figure;
                        }
                        else
                        {
                            this._view.findChildByName("reported_user_avatar").visible = false;
                            this._reportedUserName = this._habboHelp.reportedUserName;
                        }
                        this._view.findChildByName("reported_user_name").caption = this._reportedUserName;
                    }
            }
        }
    }

