package com.sulake.habbo.messenger
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.window.widgets.IIlluminaInputHandler;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import flash.utils.Timer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.window.widgets.IIlluminaInputWidget;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.friendlist.IFriend;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.core.utils.ErrorReportStorage;
    import com.sulake.core.window.components.IRegionWindow;
    import flash.events.TimerEvent;
    import com.sulake.habbo.messenger.events.NewMessageEvent;
    import com.sulake.habbo.window.widgets.IIlluminaChatBubbleWidget;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.friendlist.VisitUserMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.tracking.EventLogMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.GetHabboGroupDetailsMessageComposer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.friendlist.SendMsgMessageComposer;
    import com.sulake.habbo.catalog.habbicons.HabbiconController;
    import com.sulake.habbo.communication.messages.parser.habbicons.HabbiconMessengerContent;
    import com.sulake.habbo.messenger.habbicons.MessengerHabbiconPicker;

     class MainView implements IDisposable implements  IIlluminaInputHandler
    {
        static inline final HIDDEN= "HIDDEN";
        static inline final NO_CONVERSATION= -1;
        static inline final NOTIFICATION_ICON_WIDTH= 55;
        static inline final CHAT_ITEM_RENDER_BUNDLE_SIZE= 5;
        static inline final SCROLL_TRIGGER_HEIGHT= 150;
        static inline final COMBINE_TIME_WINDOW:Float = 600000;
        static final ERROR_MESSAGES:ASDictionary<ASAny,ASAny> = new ASDictionary();
        static var NEXT_HABBICON_CONFIRMATION_ID:Int = 1;

        var _messenger:HabboMessenger;
        var _frame:IWindowContainer;
        var _conversationList:IItemListWindow;
        var _avatarList:IWindowContainer;
        var _avatarListPosition:Int = 0;
        var _avatarListLastNotShown:Bool = false;
        var _chatEntries:ASDictionary<ASAny,ASAny>;
        var _currentConversationId:Int = -1;
        var _oldestRenderedIndex:Int = -1;
        var _avatarTemplate:IWindowContainer;
        var _chatMessageTemplate:IWidgetWindow;
        var _chatNotificationTemplate:IWindowContainer;
        var _chatInvitationTemplate:IWindowContainer;
        var _chatInfoTemplate:IWindowContainer;
        var _populatingList:Bool = false;
        var _moderationInfoShown:Bool = false;
        var _pendingMessages:Array<ASAny>;
        var _batchUpdatingTimer:Timer;
        var _habbiconButton:IWindow;
        var _inputWidget:IWindow;
        var _habbiconPicker:MessengerHabbiconPicker;

        public function new(k:HabboMessenger)
        {
            this._chatEntries = new ASDictionary<ASAny,ASAny>();
            this._messenger = k;
            this._frame = Std.downcast(this._messenger.getXmlWindow("messenger") , IWindowContainer);
            this._frame.visible = false;
            this._frame.procedure = this.messengerWindowProcedure;
            cast(this._frame.findChildByName("header_button_image"), IStaticBitmapWrapperWindow).assetUri = "messenger_minimize_button";
            this._avatarList = Std.downcast(this._frame.findChildByName("avatar_list") , IWindowContainer);
            this._avatarTemplate = Std.downcast(this._avatarList.getChildAt(0) , IWindowContainer);
            this._avatarList.removeChild(this._avatarTemplate);
            this._avatarListPosition = 0;
            this._conversationList = Std.downcast(this._frame.findChildByName("conversation") , IItemListWindow);
            this._chatMessageTemplate = Std.downcast(this._conversationList.getListItemByName("msg_normal") , IWidgetWindow);
            this._chatNotificationTemplate = Std.downcast(this._conversationList.getListItemByName("msg_notification") , IWindowContainer);
            this._chatInvitationTemplate = Std.downcast(this._conversationList.getListItemByName("msg_invitation") , IWindowContainer);
            this._chatInfoTemplate = Std.downcast(this._conversationList.getListItemByName("msg_info") , IWindowContainer);
            this._conversationList.removeListItems();
            this._inputWidget = this._frame.findChildByName("input_widget");
            cast(cast(this._inputWidget, IWidgetWindow).widget, IIlluminaInputWidget).submitHandler = this;
            this._habbiconButton = this._frame.findChildByName("habbicon_button");
            this._pendingMessages = new Array<ASAny>();
        }

        static function avatarVisible(k:IWindow):Bool
        {
            return (!(k == null)) && (k.tags.indexOf(HIDDEN) < 0);
        }

        static function setAvatarVisibilityTag(k:IWindow, _arg_2:Bool)
        {
            if (k == null)
            {
                return;
            }
            var _local_3= avatarVisible(k);
            if ((_local_3 && (!_arg_2)))
            {
                k.tags.push(HIDDEN);
            }
            else
            {
                if (((!_local_3) && _arg_2))
                {
                    k.tags.splice(k.tags.indexOf(HIDDEN), 1);
                }
            }
        }


        public function dispose()
        {
            if (!this.disposed)
            {
                this._conversationList = null;
                this._avatarList = null;
                if (this._frame != null)
                {
                    this._frame.dispose();
                    this._frame = null;
                }
                if (this._chatMessageTemplate != null)
                {
                    this._chatMessageTemplate.dispose();
                    this._chatMessageTemplate = null;
                }
                if (this._chatNotificationTemplate != null)
                {
                    this._chatNotificationTemplate.dispose();
                    this._chatNotificationTemplate = null;
                }
                if (this._chatInvitationTemplate != null)
                {
                    this._chatInvitationTemplate.dispose();
                    this._chatInvitationTemplate = null;
                }
                if (this._chatInfoTemplate != null)
                {
                    this._chatInfoTemplate.dispose();
                    this._chatInfoTemplate = null;
                }
                if (this._avatarTemplate != null)
                {
                    this._avatarTemplate.dispose();
                    this._avatarTemplate = null;
                }
                if (this._batchUpdatingTimer != null)
                {
                    if (this._batchUpdatingTimer.running)
                    {
                        this._batchUpdatingTimer.stop();
                    }
                    this._batchUpdatingTimer = null;
                }
                if (this._habbiconPicker != null)
                {
                    this._habbiconPicker.dispose();
                    this._habbiconPicker = null;
                }
                this._chatEntries = null;
                this._messenger = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._messenger == null;
        }

        public var isOpen(get,never):Bool;
public function  get_isOpen():Bool
        {
            return (!(this._frame == null)) && this._frame.visible;
        }

        public function toggle()
        {
            if (this.isOpen)
            {
                this.hide();
            }
            else
            {
                this.show();
            }
        }

        public function show(k:Bool=false)
        {
            if ((k || (this.visibleAvatarCount > 0)))
            {
                this._frame.visible = true;
                this._frame.activate();
            }
        }

        public function hide()
        {
            if (this._habbiconPicker != null)
            {
                this._habbiconPicker.hide();
            }
            this._frame.visible = false;
        }

        public function startConversation(k:Int, _arg_2:Bool=true)
        {
            var _local_3:IFriend = null;
            var _local_4:IWindowContainer = null;
            var _local_5:IWidgetWindow = null;
            var _local_6:IWidgetWindow = null;
            var _local_7:IAvatarImageWidget = null;
            var _local_8:IBadgeImageWidget = null;
            if (!this._chatEntries.exists(k ))
            {
                this._chatEntries[k] = ([] : Array<Dynamic>);
                if (!this._moderationInfoShown)
                {
                    this.recordNotificationMessage(k, "${messenger.moderationinfo}");
                    this._moderationInfoShown = true;
                }
                _local_3 = this._messenger.getFriend(k);
                if (_local_3 == null)
                {
                    ErrorReportStorage.addDebugData("Messenger Mainview", ("User got start conversation request from nonexistent friend, id: " + Std.string(k)));
                    return;
                }
                if (!_local_3.online)
                {
                    this.recordNotificationMessage(k, "${messenger.notification.persisted_messages}");
                }
                _local_4 = Std.downcast(this._avatarTemplate.clone() , IWindowContainer);
                setAvatarVisibilityTag(_local_4, true);
                _local_4.blend = 0;
                _local_4.id = k;
                if (k < 0)
                {
                    _local_4.name = Std.string(k);
                }
                _local_5 = Std.downcast(_local_4.findChildByName("avatar_image") , IWidgetWindow);
                _local_6 = Std.downcast(_local_4.findChildByName("group_badge_image") , IWidgetWindow);
                if (_local_3.id > 0)
                {
                    _local_7 = Std.downcast(_local_5.widget , IAvatarImageWidget);
                    if (_local_3 != null)
                    {
                        _local_7.figure = _local_3.figure;
                    }
                    _local_6.visible = false;
                    _local_5.visible = true;
                }
                else
                {
                    _local_8 = Std.downcast(_local_6.widget , IBadgeImageWidget);
                    _local_8.badgeId = _local_3.figure;
                    _local_8.groupId = _local_3.id;
                    _local_6.visible = true;
                    _local_5.visible = false;
                }
                cast(_local_4.findChildByName("avatar_click_region"), IRegionWindow).toolTipCaption = _local_3.name;
                this._avatarList.addChild(_local_4);
                this.refreshAvatarList();
            }
            if ((_arg_2 || (!this.isOpen)))
            {
                this.selectConversation(k);
            }
            this.refreshChatCount();
        }

        public function addConsoleMessage(k:Int, _arg_2:String, _arg_3:Int, _arg_4:String)
        {
            this.recordChatMessage(k, _arg_2, true, _arg_3, _arg_4);
        }

        public function addHabbiconConsoleMessage(chatId:Int, contentType:Int, messageText:String, habbiconId:Int, secondsSinceSent:Int, messageId:String, confirmationId:Int, senderId:Int, senderName:String, senderFigure:String)
        {
            var fromOther= senderId != this._messenger.sessionDataManager.userId;
            if (contentType == HabbiconMessengerContent.MESSAGE_TYPE_HABBICON)
            {
                this.recordHabbiconMessage(chatId, habbiconId, fromOther, secondsSinceSent, senderId, senderName, senderFigure, messageId, confirmationId);
            }
            else
            {
                this.recordChatMessage(chatId, messageText, fromOther, secondsSinceSent, this.buildExtraData(senderName, senderFigure, senderId));
            }
        }

        public function addRoomInvite(k:Int, _arg_2:String)
        {
            this.recordInvitationMessage(k, ((this._messenger.getText("messenger.invitation") + " ") + _arg_2), true);
        }

        public function setFollowingAllowed(k:Int, _arg_2:Bool)
        {
            if (k == this._currentConversationId)
            {
                this.refreshButtons();
            }
        }

        public function onInstantMessageError(k:Int, _arg_2:Int, _arg_3:String)
        {
            var _local_4:String = null;
            var _local_5:compat.RegExp = null;
            if (ERROR_MESSAGES.exists(_arg_2 ))
            {
                if (_arg_3.length > 0)
                {
                    _local_4 = ERROR_MESSAGES[_arg_2];
                    _local_5 = new compat.RegExp("[${}]", "g");
                    _local_4 = _local_5.replace(_local_4, "");
                    this.recordNotificationMessage(k, ((this._messenger.getText(_local_4) + ": ") + _arg_3));
                }
                else
                {
                    this.recordNotificationMessage(k, ERROR_MESSAGES[_arg_2]);
                }
            }
        }

        public function setOnlineStatus(k:Int, _arg_2:Bool)
        {
            if (this._chatEntries.exists(k ))
            {
                this.recordInfoMessage(k, (_arg_2 ? "${messenger.notification.online}" : "${messenger.notification.offline}"));
            }
        }

        function selectConversation(k:Int)
        {
            this._currentConversationId = k;
            setAvatarVisibilityTag(this.getAvatarWrapper(k), true);
            this.setChatIndicatorVisibility(k, false);
            this.refreshConversationList();
            this.refreshAvatarList();
            var _local_2= this._messenger.getFriend(this._currentConversationId);
            var _local_3= ((_local_2 != null) ? _local_2.name : "");
            this._frame.findChildByName("separator_label").visible = ((this._currentConversationId < 0) || (!(_local_2 == null)));
            this._messenger.localization.registerParameter("messenger.window.separator", "friend_name", _local_3);
            this._messenger.localization.registerParameter("messenger.window.input.default", "friend_name", _local_3);
            this._frame.invalidate();
        }

        public function hideConversation(k:Int)
        {
            var _local_2:IWindow = this.getAvatarWrapper(k);
            if (_local_2 != null)
            {
                setAvatarVisibilityTag(_local_2, false);
            }
            if (this.visibleAvatarCount == 0)
            {
                this.selectConversation(NO_CONVERSATION);
                this.hide();
            }
            else
            {
                final _iter_ = this._avatarList.iterator; if (checkNullIteratee(_iter_)) for (_tmp_ in com.sulake.core.utils.ASProxy.values(_iter_))
                {
_local_2  = _tmp_;
                    if (avatarVisible(_local_2))
                    {
                        this._avatarListPosition = 0;
                        this.selectConversation(_local_2.id);
                        break;
                    }
                }
            }
            this.refreshChatCount();
        }

        function refreshChatCount()
        {
            this._messenger.localization.registerParameter("messenger.window.title", "open_chat_count", Std.string(this.visibleAvatarCount));
            this._messenger.conversationCountUpdated(this.visibleAvatarCount);
        }

        function recordChatMessage(k:Int, _arg_2:String, _arg_3:Bool, _arg_4:Int, _arg_5:String=null)
        {
            if (_arg_3)
            {
                this.recordChatEntry(k, new ChatEntry(ChatEntry.TYPE_OTHER_CHAT, k, _arg_2, _arg_4, _arg_5), true);
            }
            else
            {
                this.recordChatEntry(k, new ChatEntry(ChatEntry.TYPE_OWN_CHAT, 0, _arg_2, _arg_4));
            }
        }

        function recordHabbiconMessage(conversationId:Int, habbiconId:Int, fromOther:Bool, secondsSinceSent:Int, senderId:Int, senderName:String, senderFigure:String, messageId:String=null, confirmationId:Int=0)
        {
            var type= fromOther ? ChatEntry.TYPE_OTHER_CHAT : ChatEntry.TYPE_OWN_CHAT;
            var entrySenderId= fromOther ? senderId : 0;
            var extraData= this.buildExtraData(senderName, senderFigure, senderId);
            this.recordChatEntry(conversationId, new ChatEntry(type, entrySenderId, "", secondsSinceSent, extraData, ChatEntry.CONTENT_HABBICON, habbiconId, messageId, confirmationId), fromOther);
        }

        function recordNotificationMessage(k:Int, _arg_2:String)
        {
            this.recordChatEntry(k, new ChatEntry(ChatEntry.TYPE_NOTIFICATION, 0, _arg_2, 0));
        }

        function recordInfoMessage(k:Int, _arg_2:String, _arg_3:Bool=false)
        {
            this.recordChatEntry(k, new ChatEntry(ChatEntry.TYPE_INFO, 0, _arg_2, 0), _arg_3);
        }

        function recordInvitationMessage(k:Int, _arg_2:String, _arg_3:Bool=false)
        {
            this.recordChatEntry(k, new ChatEntry(ChatEntry.TYPE_INVITATION, 0, _arg_2, 0), _arg_3);
        }

        function recordChatEntry(k:Int, _arg_2:ChatEntry, _arg_3:Bool=false)
        {
            var _local_6:ChatEntry = null;
            if (this._messenger == null)
            {
                return;
            }
            if (!this._messenger.hasfriendsListInitialized)
            {
                this._pendingMessages.push(new ChatQueueEntry(k, _arg_2, _arg_3));
                if (((!(this._batchUpdatingTimer != null)) || ((this._batchUpdatingTimer != null) && (!this._batchUpdatingTimer.running))))
                {
                    this._batchUpdatingTimer = new Timer(12000);
                    this._batchUpdatingTimer.addEventListener(TimerEvent.TIMER, (this.batchMessageUpdate : ASAny));
                    this._batchUpdatingTimer.start();
                }
                return;
            }
            if (!this._chatEntries.exists(k ))
            {
                this.startConversation(k, false);
            }
            var _local_4:Array<ASAny> = this._chatEntries[k];
            _local_6 = ((_local_4.length > 0) ? _local_4[(_local_4.length - 1)] : null);
            _local_4.push(_arg_2);
            var _local_5= this.getAvatarWrapper(k);
            if (_local_5 != null)
            {
                setAvatarVisibilityTag(_local_5, true);
                this.refreshAvatarList();
            }
            if (k == this._currentConversationId)
            {
                this.addToConversationAndCombine(_arg_2, _local_6);
                if (this._oldestRenderedIndex == -1)
                {
                    this._oldestRenderedIndex = (_local_4.length - 1);
                }
                this._conversationList.scrollV = 1;
                this._conversationList.arrangeListItems();
            }
            else
            {
                if (_arg_3)
                {
                    this.setChatIndicatorVisibility(k, true);
                }
                if (this.visibleAvatarCount == 1)
                {
                    this.selectConversation(k);
                }
            }
            this.refreshChatCount();
        }

        function batchMessageUpdate(k:TimerEvent)
        {
            var _local_2 = 0;
            var _local_3:ChatQueueEntry = null;
            if (this._messenger == null)
            {
                return;
            }
            if (this._messenger.hasfriendsListInitialized)
            {
                if (this._pendingMessages.length > 0)
                {
                    _local_2 = -1;
                    final _iter_ = this._pendingMessages; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
_local_3  = _tmp_;
                        _local_2 = _local_3._Str_20358;
                        this.recordChatEntry(_local_3._Str_20358, _local_3._Str_24552, _local_3._Str_24452);
                    }
                    this.refreshConversationList();
                    this.refreshAvatarList();
                    this._messenger.events.dispatchEvent(new NewMessageEvent(true, _local_2));
                }
                this._pendingMessages = new Array<ASAny>();
                this._batchUpdatingTimer.stop();
            }
        }

        function getAvatarWrapper(k:Int):IWindowContainer
        {
            return Std.downcast(this._avatarList.getChildByID(k) , IWindowContainer);
        }

        function setChatIndicatorVisibility(k:Int, _arg_2:Bool)
        {
            var _local_3= this.getAvatarWrapper(k);
            if (_local_3 != null)
            {
                _local_3.findChildByName("chat_indicator").visible = _arg_2;
            }
        }

        function createChatItem(k:ChatEntry):IWindow
        {
            var _local_2:IWidgetWindow = null;
            var _local_3:IIlluminaChatBubbleWidget = null;
            var _local_4:IWindowContainer = null;
            var _local_5:IWindow = null;
            var _local_6:IWindowContainer = null;
            var _local_7:IWindowContainer = null;
            var _local_8:IFriend = null;
            var _local_9:IWindowContainer = null;
            var _local_10 = false;
            switch (k.type)
            {
                case ChatEntry.TYPE_INFO:
                    _local_4 = Std.downcast(this._chatInfoTemplate.clone() , IWindowContainer);
                    _local_5 = _local_4.findChildByName("content");
                    _local_5.limits.minWidth = this.conversationItemWidth;
                    _local_5.limits.maxWidth = this.conversationItemWidth;
                    _local_5.caption = k.message;
                    return _local_4;
                case ChatEntry.TYPE_NOTIFICATION:
                    _local_6 = Std.downcast(this._chatNotificationTemplate.clone() , IWindowContainer);
                    _local_6.findChildByName("content").width = (this.conversationItemWidth - NOTIFICATION_ICON_WIDTH);
                    _local_6.findChildByName("content").caption = k.message;
                    return _local_6;
                case ChatEntry.TYPE_INVITATION:
                    _local_7 = Std.downcast(this._chatInvitationTemplate.clone() , IWindowContainer);
                    _local_7.findChildByName("content").width = (this.conversationItemWidth - NOTIFICATION_ICON_WIDTH);
                    _local_7.findChildByName("content").caption = k.message;
                    return _local_7;
                case ChatEntry.TYPE_OTHER_CHAT:
                    _local_2 = Std.downcast(this._chatMessageTemplate.clone() , IWidgetWindow);
                    _local_2.width = this.conversationItemWidth;
                    _local_3 = Std.downcast(_local_2.widget , IIlluminaChatBubbleWidget);
                    _local_3.flipped = true;
                    this.appendEntryMessage(_local_3, k);
                    _local_3.timeStamp = k._Str_22172();
                    final _iter_ = this._avatarList.iterator; if (checkNullIteratee(_iter_)) for (_tmp_ in com.sulake.core.utils.ASProxy.values(_iter_))
                    {
_local_9  = _tmp_;
                        _local_10 = ((!(_local_9 == null)) && (_local_9.id == this._currentConversationId));
                        if ((((!_local_10) && (!(_local_9 == null))) && (this._currentConversationId < 0)))
                        {
                            _local_10 = (ASCompat.toNumber(_local_9.name) == this._currentConversationId);
                        }
                        if (_local_10)
                        {
                            if (this._currentConversationId > 0)
                            {
                                _local_3.figure = cast(cast(_local_9.getChildByName("avatar_image"), IWidgetWindow).widget, IAvatarImageWidget).figure;
                                _local_3.userName = cast(_local_9.findChildByName("avatar_click_region"), IRegionWindow).toolTipCaption;
                                _local_3.userId = _local_9.id;
                            }
                            else
                            {
                                _local_3.userId = ASCompat.toInt(k.extraData.split("/")[2]);
                                _local_3.figure = k.extraData.split("/")[1];
                                _local_3.userName = k.extraData.split("/")[0];
                            }
                            break;
                        }
                    }
                    return _local_2;
                case ChatEntry.TYPE_OWN_CHAT:
                    _local_2 = Std.downcast(this._chatMessageTemplate.clone() , IWidgetWindow);
                    _local_2.width = this.conversationItemWidth;
                    _local_3 = Std.downcast(_local_2.widget , IIlluminaChatBubbleWidget);
                    _local_3.flipped = false;
                    this.appendEntryMessage(_local_3, k);
                    _local_3.timeStamp = k._Str_22172();
                    _local_3.figure = this._messenger.sessionDataManager.figure;
                    _local_3.userName = this._messenger.sessionDataManager.userName;
                    _local_8 = this._messenger.getFriend(this._currentConversationId);
                    if ((((!(_local_8 == null)) && (!_local_8.online)) && (_local_8.persistedMessageUser || _local_8.pocketHabboUser)))
                    {
                        _local_3.friendOnlineStatus = false;
                    }
                    return _local_2;
            }
            return null;
        }

        function appendEntryMessage(k:IIlluminaChatBubbleWidget, _arg_2:ChatEntry, _arg_3:Bool=false)
        {
            // Entries only ever reach us as the server's echo, which is the delivery -- there is no
            // separate confirmation packet to clear a pending id, so never render them dimmed.
            if (_arg_2.isTextMessage)
            {
                k.appendTextMessage(_arg_2.message, _arg_3, 0);
            }
            else
            {
                k.appendHabbiconMessage(_arg_2.habbiconId, _arg_3, 0);
            }
        }

        function shouldCombineWithPreviousEntry(k:Int, _arg_2:ChatEntry, _arg_3:ChatEntry):Bool
        {
            var _local_6:String = null;
            var _local_7:String = null;
            if (((_arg_2 == null) || (_arg_3 == null)))
            {
                return false;
            }
            if (!((_arg_2.type == ChatEntry.TYPE_OWN_CHAT) || (_arg_2.type == ChatEntry.TYPE_OTHER_CHAT)))
            {
                return false;
            }
            if (_arg_2.type != _arg_3.type)
            {
                return false;
            }
            if (_arg_2._Str_22172() >= (_arg_3._Str_22172() + COMBINE_TIME_WINDOW))
            {
                return false;
            }
            if (k > 0)
            {
                return true;
            }
            if (_arg_2.type == ChatEntry.TYPE_OWN_CHAT)
            {
                return true;
            }
            if (((_arg_2.extraData == null) || (_arg_3.extraData == null)))
            {
                return false;
            }
            _local_6 = _arg_3.extraData.split("/")[0];
            _local_7 = _arg_2.extraData.split("/")[0];
            return (_local_6 == _local_7);
        }

        function addToConversationAndCombine(k:ChatEntry, _arg_2:ChatEntry, _arg_3:Bool=false):Bool
        {
            var _local_4 = 0;
            var _local_5:IWidgetWindow = null;
            var _local_6:IIlluminaChatBubbleWidget = null;
            var _local_7:IWindow = null;
            if (this.shouldCombineWithPreviousEntry(this._currentConversationId, k, _arg_2))
            {
                _local_4 = (_arg_3 ? 0 : (this._conversationList.numListItems - 1));
                if (_local_4 >= 0)
                {
                    _local_5 = Std.downcast(this._conversationList.getListItemAt(_local_4) , IWidgetWindow);
                    if (_local_5 != null)
                    {
                        _local_6 = Std.downcast(_local_5.widget , IIlluminaChatBubbleWidget);
                        if (_local_6 != null)
                        {
                            this.appendEntryMessage(_local_6, k, _arg_3);
                            if (!_arg_3)
                            {
                                _local_6.timeStamp = k._Str_22172();
                            }
                            return true;
                        }
                    }
                }
            }
            _local_7 = this.createChatItem(k);
            if (_local_7 == null)
            {
                return false;
            }
            if (_arg_3)
            {
                this._conversationList.addListItemAt(_local_7, 0);
            }
            else
            {
                this._conversationList.addListItem(_local_7);
            }
            return false;
        }

        function renderOlderEntries(k:Int)
        {
            var _local_6:ChatEntry = null;
            var _local_2:Array<ASAny> = this._chatEntries[this._currentConversationId];
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= ((this._oldestRenderedIndex == -1) ? _local_2.length : this._oldestRenderedIndex);
            var _local_4:ChatEntry = ((this._oldestRenderedIndex == -1) ? null : _local_2[this._oldestRenderedIndex]);
            var _local_5 = 0;
            var _local_7= (_local_3 - 1);
            while (_local_7 >= 0)
            {
                _local_6 = _local_2[_local_7];
                this.addToConversationAndCombine(_local_6, _local_4, true);
                _local_4 = _local_6;
                this._oldestRenderedIndex = _local_7;
                _local_5++;
                if (_local_5 >= k)
                {
                    break;
                }
                _local_7--;
            }
        }

        function adjustListItemWidths()
        {
            var _local_2:IWindow = null;
            var _local_3:IWindow = null;
            var k = 0;
            while (k < this._conversationList.numListItems)
            {
                _local_2 = this._conversationList.getListItemAt(k);
                switch (_local_2.name)
                {
                    case "msg_normal":
                        
                    case "msg_notification":
                        cast(_local_2, IWindowContainer).findChildByName("content").width = (this.conversationItemWidth - NOTIFICATION_ICON_WIDTH);
                        
                    case "msg_info":
                        _local_3 = cast(_local_2, IWindowContainer).findChildByName("content");
                        _local_3.limits.minWidth = this.conversationItemWidth;
                        _local_3.limits.maxWidth = this.conversationItemWidth;
                        
                }
                _local_2.width = this.conversationItemWidth;
                k++;
            }
            this._conversationList.arrangeListItems();
            this._frame.invalidate();
        }

        var conversationItemWidth(get,never):Int;
function  get_conversationItemWidth():Int
        {
            return this._frame.width - 27;
        }

        function refreshButtons()
        {
            cast(this._frame.findChildByName("button_strip"), IItemListWindow).arrangeListItems();
        }

        function refreshConversationList()
        {
            this._populatingList = true;
            this._conversationList.destroyListItems();
            this._oldestRenderedIndex = -1;
            this.renderOlderEntries(CHAT_ITEM_RENDER_BUNDLE_SIZE);
            this._conversationList.scrollV = 1;
            this._conversationList.arrangeListItems();
            this._populatingList = false;
        }

        function addMissingChatEntries()
        {
            if (-this._conversationList.scrollableRegion.y > SCROLL_TRIGGER_HEIGHT)
            {
                return;
            }
            if (this._oldestRenderedIndex <= 0)
            {
                return;
            }
            this._populatingList = true;
            var k= this._conversationList.scrollV;
            var _local_2= Std.int(this._conversationList.scrollableRegion.height);
            this.renderOlderEntries(CHAT_ITEM_RENDER_BUNDLE_SIZE);
            this._conversationList.arrangeListItems();
            this._conversationList.scrollV = ((_local_2 <= this._conversationList.height) ? 1 : (1 - ((_local_2 * (1 - k)) / this._conversationList.scrollableRegion.height)));
            this._populatingList = false;
        }

        function refreshAvatarList()
        {
            var _local_3:IWindow = null;
            var _local_4 = false;
            var _local_5 = false;
            var k = 0;
            var _local_2 = 0;
            this._avatarListLastNotShown = false;
            final _iter_ = this._avatarList.iterator; if (checkNullIteratee(_iter_)) for (_tmp_ in com.sulake.core.utils.ASProxy.values(_iter_))
            {
_local_3  = _tmp_;
                _local_4 = (_local_3.id == this._currentConversationId);
                if (((!_local_4) && (_local_3.name.length > 0)))
                {
                    _local_4 = (ASCompat.toNumber(_local_3.name) == this._currentConversationId);
                }
                if (_local_4)
                {
                    setAvatarVisibilityTag(_local_3, true);
                }
                _local_5 = avatarVisible(_local_3);
                if ((((_local_2 < this._avatarListPosition) || (!_local_5)) || this._avatarListLastNotShown))
                {
                    _local_3.visible = false;
                }
                else
                {
                    if ((k + _local_3.width) > this._avatarList.width)
                    {
                        _local_3.visible = false;
                        this._avatarListLastNotShown = true;
                    }
                    else
                    {
                        _local_3.visible = true;
                        _local_3.blend = (_local_4 ? 1 : 0);
                        _local_3.x = k;
                        k = (k + _local_3.width);
                    }
                }
                if (_local_5)
                {
                    _local_2++;
                }
            }
            this._frame.findChildByName("avatars_scroll_left").visible = (this._avatarListPosition > 0);
            this._frame.findChildByName("avatars_scroll_right").visible = this._avatarListLastNotShown;
        }

        var visibleAvatarCount(get,never):Int;
function  get_visibleAvatarCount():Int
        {
            var _local_2:IWindow = null;
            var k = 0;
            final _iter_ = this._avatarList.iterator; if (checkNullIteratee(_iter_)) for (_tmp_ in com.sulake.core.utils.ASProxy.values(_iter_))
            {
_local_2  = _tmp_;
                if (avatarVisible(_local_2))
                {
                    k++;
                }
            }
            return k;
        }

        function messengerWindowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            switch (k.type)
            {
                case WindowEvent.WINDOW_EVENT_RESIZE:
                    if ((_arg_2 : ASAny) == (this._frame : ASAny))
                    {
                        this.adjustListItemWidths();
                        this.refreshAvatarList();
                    }
                    return;
                case WindowEvent.WINDOW_EVENT_RELOCATED:
                    if (((_arg_2.name == "_CONTAINER") && (!this._populatingList)))
                    {
                        this.addMissingChatEntries();
                    }
                    return;
                case WindowMouseEvent.CLICK:
                    switch (_arg_2.name)
                    {
                        case "avatar_click_region":
                            this.selectConversation(_arg_2.parent.id);
                            
                        case "avatars_scroll_left":
                            if (this._avatarListPosition > 0)
                            {
                                this._avatarListPosition--;
                                this.refreshAvatarList();
                            }
                            
                        case "avatars_scroll_right":
                            if (this._avatarListLastNotShown)
                            {
                                this._avatarListPosition++;
                                this.refreshAvatarList();
                            }
                            
                        case "close_conversation_button":
                            this.hideConversation(this._currentConversationId);
                            
                        case "follow_button":
                            this._messenger.send(new VisitUserMessageComposer(this._currentConversationId));
                            this._messenger.send(new EventLogMessageComposer("Navigation", "IM", "go.im"));
                            
                        case "profile_button":
                            if (this._currentConversationId > 0)
                            {
                                this._messenger.send(new GetExtendedProfileMessageComposer(this._currentConversationId));
                                this._messenger.trackGoogle("extendedProfile", "messenger_conversation");
                            }
                            else
                            {
                                this._messenger.send(new GetHabboGroupDetailsMessageComposer(Std.int(Math.abs(this._currentConversationId)), true));
                                this._messenger.trackGoogle("extendedProfile", "messenger_conversation");
                            }
                            
                        case "report_button":
                            this._messenger.reportUser(this._currentConversationId);
                            
                        case "habbicon_button"
                           | "habbicon_button_icon":
                            this.toggleHabbiconPicker();
                            
                        case "header_button_close":
                            this.hide();
                            
                    }
                    return;
            }
        }

        public function onInput(k:IWidgetWindow, _arg_2:String)
        {
            if (_arg_2 == "")
            {
                return;
            }
            if (this._habbiconPicker != null)
            {
                this._habbiconPicker.hide(false);
            }
            this._messenger.send(new SendMsgMessageComposer(this._currentConversationId, _arg_2));
            cast(k.widget, IIlluminaInputWidget).message = "";
            var _local_3:Array<ASAny> = this._chatEntries[this._currentConversationId];
            if (((_local_3.length == 0) || ((_local_3.length == 1) && (cast(_local_3[0], ChatEntry).type == ChatEntry.TYPE_NOTIFICATION))))
            {
                this._messenger.playSendSound();
            }
            this.recordChatMessage(this._currentConversationId, this.escapeExternalKeys(_arg_2), false, 0);
        }

        function escapeExternalKeys(k:String):String
        {
            if (k.indexOf("\\${") == 0)
            {
                return " " + k;
            }
            return k;
        }

        function toggleHabbiconPicker()
        {
            if (this._currentConversationId == NO_CONVERSATION)
            {
                return;
            }
            if (!this.ensureHabbiconPicker())
            {
                return;
            }
            this._habbiconPicker.toggle(this._habbiconButton, this._inputWidget);
        }

        function ensureHabbiconPicker():Bool
        {
            var controller= HabbiconController.instance;
            var pickerWindow:IWindowContainer = null;
            if (controller == null)
            {
                return false;
            }
            if (this._habbiconPicker == null || this._habbiconPicker.disposed)
            {
                pickerWindow = Std.downcast(this._messenger.getXmlWindow("messenger_habbicon_picker") , IWindowContainer);
                if (pickerWindow == null)
                {
                    return false;
                }
                this._habbiconPicker = new MessengerHabbiconPicker(pickerWindow, controller, this.onHabbiconSelected);
            }
            return true;
        }

        function onHabbiconSelected(habbiconId:Int, keepOpen:Bool=false)
        {
            var controller= HabbiconController.instance;
            if (controller == null || this._currentConversationId == NO_CONVERSATION || habbiconId <= 0)
            {
                return;
            }
            controller.sendHabbiconInstantMessage(this._currentConversationId, habbiconId, NEXT_HABBICON_CONFIRMATION_ID++);
            if (!keepOpen && this._habbiconPicker != null)
            {
                this._habbiconPicker.hide(false);
            }
        }

        function buildExtraData(senderName:String, senderFigure:String, senderId:Int):String
        {
            return ((senderName != null ? senderName : "") + "/" + (senderFigure != null ? senderFigure : "") + "/" + Std.string(senderId));
        }

	static final ___init = {

        {
            ERROR_MESSAGES[3] = "${messenger.error.receivermuted}";
            ERROR_MESSAGES[4] = "${messenger.error.sendermuted}";
            ERROR_MESSAGES[5] = "${messenger.error.offline}";
            ERROR_MESSAGES[6] = "${messenger.error.notfriend}";
            ERROR_MESSAGES[7] = "${messenger.error.busy}";
            ERROR_MESSAGES[8] = "${messenger.error.receiverhasnochat}";
            ERROR_MESSAGES[9] = "${messenger.error.senderhasnochat}";
            ERROR_MESSAGES[10] = "${messenger.error.offline_failed}";
        }

	null;
	};
    }

