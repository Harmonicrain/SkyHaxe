package com.sulake.habbo.moderation
;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.communication.messages.parser.moderation.IssueMessageData;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.communication.messages.incoming.callforhelp.CallForHelpCategoryData;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.habbo.communication.messages.outgoing.moderator.GetCfhChatlogMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.moderator.ModToolPreferencesComposer;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.communication.messages.incoming.callforhelp.CallForHelpTopicData;

     class IssueHandler implements ITrackedWindow implements  IIssueHandler implements  IUpdateReceiver 
    {
        static inline final _Str_18250= 27;
        static inline final _Str_13006= 28;
        static inline final _Str_12881= 1;
        static inline final _Str_18676= 3;

        var _moderationManager:ModerationManager;
        var _issueBundle:IssueBundle;
        var _selectedIssue:IssueMessageData;
        var _window:IFrameWindow;
        var _cfhCategories:Vector<CallForHelpCategoryData>;
        var _topicIdByDropdownIdx:Array<ASAny>;
        var _topicDropdown:IDropMenuWindow;
        var _callerUserInfo:UserInfoCtrl;
        var _reportedUserInfo:UserInfoCtrl;
        var _disposed:Bool = false;
        var _sexualTalkTopicItemIndex:Int = 0;
        var _chatLogCtrl:ChatlogCtrl;
        var _chatFrame:IWindowContainer;
        var _chatList:IItemListWindow;
        var _actionCount:Int = 0;
        var _lastWindowX:Int = 0;
        var _lastWindowY:Int = 0;
        var _lastWindowWidth:Int = 0;
        var _lastWindowHeight:Int = 0;
        var _lastWindowPreferencesMessageSentAt:UInt = 0;
        var _issueItemPrototype:IWindowContainer;
        var _messageItemPrototype:ITextFieldWindow;

        public function new(k:ModerationManager, _arg_2:IssueBundle, _arg_3:Vector<CallForHelpCategoryData>, _arg_4:Int, _arg_5:Int, _arg_6:Int, _arg_7:Int)
        {
            this._lastWindowPreferencesMessageSentAt = flash.Lib.getTimer();
            this._moderationManager = k;
            this._issueBundle = _arg_2;
            this._cfhCategories = _arg_3;
            this._lastWindowX = _arg_4;
            this._lastWindowY = _arg_5;
            this._lastWindowWidth = _arg_6;
            this._lastWindowHeight = _arg_7;
        }

        public function getType():Int
        {
            return WindowTracker._Str_18611;
        }

        public function getId():String
        {
            return "" + Std.string(this._issueBundle.id);
        }

        public function getFrame():IFrameWindow
        {
            return this._window;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._callerUserInfo != null)
            {
                this._callerUserInfo.dispose();
                this._callerUserInfo = null;
            }
            if (this._reportedUserInfo != null)
            {
                this._reportedUserInfo.dispose();
                this._reportedUserInfo = null;
            }
            if (this._chatLogCtrl != null)
            {
                this._chatLogCtrl.dispose();
                this._chatLogCtrl = null;
            }
            if (this._issueItemPrototype != null)
            {
                this._issueItemPrototype.dispose();
                this._issueItemPrototype = null;
            }
            if (this._messageItemPrototype != null)
            {
                this._messageItemPrototype.dispose();
                this._messageItemPrototype = null;
            }
            this._moderationManager.removeUpdateReceiver(this);
            this._moderationManager = null;
            this._issueBundle = null;
        }

        public function show()
        {
            var _local_6:IItemListWindow = null;
            var _local_7:IWindow = null;
            if (this._window != null)
            {
                return;
            }
            if (((this._moderationManager.windowManager == null) || (this._moderationManager.assets == null)))
            {
                return;
            }
            this._window = Std.downcast(this._moderationManager.getXmlWindow("issue_handler") , IFrameWindow);
            if (this._window == null)
            {
                return;
            }
            var k= Std.downcast(this._window.findChildByName("issues_item_list") , IItemListWindow);
            this._issueItemPrototype = Std.downcast(k.getListItemAt(0) , IWindowContainer);
            k.removeListItems();
            var _local_2= Std.downcast(this._window.findChildByName("msg_item_list") , IItemListWindow);
            this._messageItemPrototype = Std.downcast(_local_2.getListItemAt(0) , ITextFieldWindow);
            _local_2.removeListItems();
            var _local_3= this._window.findChildByTag("close");
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowMouseEvent.CLICK, this.onCloseHandler);
            }
            _local_3 = this._window.findChildByName("issue_cont");
            if (_local_3 != null)
            {
                _local_3.addEventListener(WindowEvent.WINDOW_EVENT_RELOCATED, this._Str_20739);
                _local_3.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this._Str_20739);
                this._moderationManager.registerUpdateReceiver(this, 1000);
            }
            this._lastWindowPreferencesMessageSentAt = flash.Lib.getTimer();
            this.setProc("close_useless", this._Str_23692);
            this.setProc("close_sanction", this._Str_23381);
            this.setProc("close_resolved", this._Str_23537);
            this.setProc("release", this._Str_15257);
            _local_3 = this._window.findChildByName("move_to_player_support");
            if (_local_3 != null)
            {
                _local_3.disable();
            }
            this._moderationManager.issueManager.requestSanctionData(this._issueBundle.id, -1);
            this._Str_17163();
            this._selectedIssue = this._issueBundle._Str_5216();
            this._callerUserInfo = new UserInfoCtrl(this._window, this._moderationManager, this._selectedIssue, this);
            this._reportedUserInfo = new UserInfoCtrl(this._window, this._moderationManager, this._selectedIssue, this);
            this._callerUserInfo.load(cast(this._window.findChildByName("caller_user_info"), IWindowContainer), this._selectedIssue._Str_19929);
            if (((this._selectedIssue.categoryId == _Str_18676) && (this._selectedIssue._Str_7437 == _Str_13006)))
            {
                this._topicDropdown.selection = this._sexualTalkTopicItemIndex;
                this._moderationManager.issueManager.requestSanctionData(this._issueBundle.id, _Str_12881);
            }
            var _local_4= cast(this._window.findChildByName("reported_user_info"), IWindowContainer);
            if (this._issueBundle.reportedUserId > 0)
            {
                this._reportedUserInfo.load(_local_4, this._issueBundle.reportedUserId);
            }
            else
            {
                _local_6 = cast(this._window.findChildByName("issue_cont"), IItemListWindow);
                _local_7 = this._window.findChildByName("reported_user_info_caption");
                _local_6.removeListItem(_local_7);
                _local_6.removeListItem(_local_4);
            }
            var _local_5= Std.downcast(this._window.findChildByName("handle_next_checkbox") , ICheckBoxWindow);
            if (_local_5 != null)
            {
                _local_5.select();
            }
            this._chatFrame = cast(this._window.findChildByName("chat_cont"), IWindowContainer);
            this._chatList = cast(this._chatFrame.findChildByName("evidence_list"), IItemListWindow);
            this._chatLogCtrl = new ChatlogCtrl(new GetCfhChatlogMessageComposer(this._selectedIssue._Str_2869), this._moderationManager, WindowTracker._Str_15411, this._selectedIssue._Str_2869, this._selectedIssue, this._chatFrame, this._chatList, true);
            this._chatLogCtrl.show();
            Logger.log([("HARASSER: " + Std.string(this._issueBundle.reportedUserId))]);
            this._Str_21213();
            this._Str_21255();
        }

        function sendWindowPreferences()
        {
            this._lastWindowX = this._window.x;
            this._lastWindowY = this._window.y;
            this._lastWindowWidth = this._window.width;
            this._lastWindowHeight = this._window.height;
            this._moderationManager.issueManager.setToolPreferences(this._lastWindowX, this._lastWindowY, this._lastWindowWidth, this._lastWindowHeight);
            this._moderationManager.connection.send(new ModToolPreferencesComposer(this._lastWindowX, this._lastWindowY, this._lastWindowWidth, this._lastWindowHeight));
        }

        function _Str_25789():Bool
        {
            if (this._lastWindowX != this._window.x)
            {
                return true;
            }
            if (this._lastWindowY != this._window.y)
            {
                return true;
            }
            if (this._lastWindowWidth != this._window.width)
            {
                return true;
            }
            if (this._lastWindowHeight != this._window.height)
            {
                return true;
            }
            return false;
        }

        public function update(k:UInt)
        {
            var _local_2:UInt = flash.Lib.getTimer();
            if ((this._Str_25789() && ((_local_2 - this._lastWindowPreferencesMessageSentAt) > 5000)))
            {
                this.sendWindowPreferences();
            }
        }

        function _Str_20739(k:WindowEvent)
        {
            var _local_2= Std.downcast(k.window , IItemListWindow);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= Std.downcast(_local_2.getListItemByName("issues_item_list") , IItemListWindow);
            var _local_4= Std.downcast(_local_2.getListItemByName("msg_item_list") , IItemListWindow);
            if (((_local_3 == null) || (_local_4 == null)))
            {
                return;
            }
            var _local_5= Std.int((((_local_2.height - _local_2.scrollableRegion.height) + _local_3.height) + _local_4.height) * 0.5);
            _local_2.autoArrangeItems = false;
            _local_3.height = _local_5;
            _local_4.height = _local_5;
            _local_2.autoArrangeItems = true;
        }

        function _Str_21213()
        {
            var _local_4:IWindowContainer = null;
            var _local_9:IssueMessageData = null;
            var _local_11:IWindowContainer = null;
            var _local_12:IWindow = null;
            var _local_13:String = null;
            if (this._window == null)
            {
                return;
            }
            var k= Std.downcast(this._window.findChildByName("issues_item_list") , IItemListWindow);
            if (k == null)
            {
                return;
            }
            var _local_2= this._issueBundle.issues;
            var _local_3 = 0;
            var _local_5= k.numListItems;
            var _local_6= _local_2.length;
            if (_local_5 < _local_6)
            {
                _local_4 = Std.downcast(this._issueItemPrototype.clone() , IWindowContainer);
                k.addListItem(_local_4);
                _local_3 = 1;
                while (_local_3 < (_local_6 - _local_5))
                {
                    _local_11 = Std.downcast(_local_4.clone() , IWindowContainer);
                    if (_local_11 == null)
                    {
                        return;
                    }
                    k.addListItem(_local_11);
                    _local_3++;
                }
            }
            else
            {
                if (_local_5 > _local_6)
                {
                    _local_3 = 0;
                    while (_local_3 < (_local_5 - _local_6))
                    {
                        _local_12 = k.removeListItemAt(0);
                        _local_12.dispose();
                        _local_3++;
                    }
                }
            }
            var _local_7= this._issueBundle._Str_5216();
            var _local_8= ((_local_7 == null) ? 0 : _local_7._Str_2869);
            var _local_10= flash.Lib.getTimer();
            _local_3 = 0;
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_9  = _tmp_;
                _local_4 = Std.downcast(k.getListItemAt(_local_3) , IWindowContainer);
                if (_local_4 == null)
                {
                    return;
                }
                _local_4.background = ((_local_3++ % 2) == 0);
                _local_4.id = _local_9._Str_2869;
                _local_4.removeEventListener(WindowMouseEvent.CLICK, this._Str_20796);
                _local_4.addEventListener(WindowMouseEvent.CLICK, this._Str_20796);
                this._Str_4180(_local_4.findChildByName("reporter"), _local_9._Str_19615);
                this._Str_4180(_local_4.findChildByName("type"), IssueCategoryNames._Str_21676(_local_9.categoryId));
                this._Str_4180(_local_4.findChildByName("category"), IssueCategoryNames._Str_21569(_local_9._Str_7437));
                this._Str_4180(_local_4.findChildByName("time_open"), _local_9._Str_15885(_local_10));
                _local_13 = (((_local_9._Str_2869 == _local_8) && (_local_6 > 1)) ? "Volter Bold" : "Volter");
                Std.downcast(_local_4.findChildByName("category") , ITextWindow).fontFace = _local_13;
            }
        }

        function _Str_21255()
        {
            var _local_4:ITextFieldWindow = null;
            var _local_7:IssueMessageData = null;
            var _local_8:ITextWindow = null;
            var _local_9:IWindow = null;
            if (this._window == null)
            {
                return;
            }
            var k= Std.downcast(this._window.findChildByName("msg_item_list") , IItemListWindow);
            if (k == null)
            {
                return;
            }
            var _local_2= this._issueBundle.issues;
            var _local_3 = 0;
            var _local_5= k.numListItems;
            var _local_6= _local_2.length;
            if (_local_5 < _local_6)
            {
                _local_4 = Std.downcast(this._messageItemPrototype.clone() , ITextFieldWindow);
                _local_4.selectable = true;
                _local_4.editable = false;
                k.addListItem(_local_4);
                _local_3 = 1;
                while (_local_3 < (_local_6 - _local_5))
                {
                    _local_8 = Std.downcast(_local_4.clone() , ITextWindow);
                    if (_local_8 == null)
                    {
                        return;
                    }
                    k.addListItem(_local_8);
                    _local_3++;
                }
            }
            else
            {
                if (_local_5 > _local_6)
                {
                    _local_3 = 0;
                    while (_local_3 < (_local_5 - _local_6))
                    {
                        _local_9 = k.removeListItemAt(0);
                        _local_9.dispose();
                        _local_3++;
                    }
                }
            }
            _local_3 = 0;
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_7  = _tmp_;
                _local_4 = Std.downcast(k.getListItemAt(_local_3) , ITextFieldWindow);
                if (_local_4 == null)
                {
                    return;
                }
                _local_4.width = k.width;
                _local_4.background = ((_local_3++ % 2) == 0);
                _local_4.caption = ((_local_7._Str_19615 + ": ") + _local_7.message);
                _local_4.height = Std.int(_local_4.textHeight + 10);
            }
        }

        function _Str_4180(k:IWindow, _arg_2:String)
        {
            if (k != null)
            {
                k.caption = _arg_2;
            }
        }

        function _Str_17163()
        {
            var _local_5:CallForHelpCategoryData = null;
            var _local_6:CallForHelpTopicData = null;
            this._topicDropdown = Std.downcast(this._window.findChildByName("cfh_topics") , IDropMenuWindow);
            var k= -1;
            var _local_2= this._issueBundle._Str_5216()._Str_7437;
            if (_local_2 == _Str_18250)
            {
                this._topicDropdown.disable();
                return;
            }
            this._topicIdByDropdownIdx = [];
            var _local_3:Array<ASAny> = [];
            var _local_4 = 0;
            final _iter_ = this._cfhCategories; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                final _iter_ = _local_5._Str_14841; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_6  = _tmp_;
                    _local_3[_local_4] = (("${help.cfh.topic." + Std.string(_local_6.id)) + "}");
                    this._topicIdByDropdownIdx[_local_4] = _local_6.id;
                    if (_local_6.id == _Str_12881)
                    {
                        this._sexualTalkTopicItemIndex = _local_4;
                    }
                    if (_local_6.id == _local_2)
                    {
                        k = _local_4;
                    }
                    _local_4++;
                }
            }
            this._topicDropdown.populate(_local_3);
            if (k >= 0)
            {
                this._topicDropdown.selection = k;
            }
            this._topicDropdown.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this._Str_17950);
        }

        function _Str_17950(k:WindowEvent)
        {
            var _local_2= this._topicDropdown.selection;
            var _local_3= ASCompat.toInt(this._topicIdByDropdownIdx[_local_2]);
            this._moderationManager.issueManager.requestSanctionData(this._issueBundle.id, _local_3);
        }

        function setProc(k:String, _arg_2:ASFunction)
        {
            this._window.findChildByName(k).addEventListener(WindowMouseEvent.CLICK, _arg_2);
        }

        function onCloseHandler(k:WindowMouseEvent)
        {
            if ((((!(this._moderationManager == null)) && (!(this._moderationManager.issueManager == null))) && (!(this._issueBundle == null))))
            {
                this._moderationManager.issueManager._Str_17098(this._issueBundle.id);
                this.trackAction("closeWindow");
            }
            this.dispose();
        }

        function _Str_23692(k:WindowMouseEvent)
        {
            Logger.log(["Close useless clicked"]);
            this.trackAction("closeUseless");
            this._moderationManager.trackGoogle("actionCountUseless", this._actionCount);
            this._moderationManager.issueManager.closeBundle(this._issueBundle.id, IssueManager.RESOLUTION_USELESS);
            this._Str_13345();
            this.dispose();
        }

        function _Str_23537(k:WindowMouseEvent)
        {
            Logger.log(["Close resolved clicked"]);
            this.trackAction("closeResolved");
            this._moderationManager.trackGoogle("actionCountResolved", this._actionCount);
            this._moderationManager.issueManager.closeBundle(this._issueBundle.id, IssueManager.RESOLUTION_RESOLVED);
            this._Str_13345();
            this.dispose();
        }

        function _Str_23381(k:WindowMouseEvent)
        {
            Logger.log(["Close with default sanction clicked"]);
            this.trackAction("closeSanction");
            this._moderationManager.trackGoogle("actionCountSanction", this._actionCount);
            var _local_2= -1;
            var _local_3= this._topicDropdown.selection;
            if (_local_3 >= 0)
            {
                _local_2 = ASCompat.toInt(this._topicIdByDropdownIdx[_local_3]);
            }
            if (((_local_2 <= 0) && (this._issueBundle._Str_5216()._Str_7437 == _Str_13006)))
            {
                this._moderationManager.windowManager.alert("Topic missing", "You need to select the topic first.", 0, null);
            }
            else
            {
                this._moderationManager.issueManager.closeDefaultAction(this._issueBundle.id, _local_2);
                this._Str_13345();
                this.dispose();
            }
        }

        function _Str_15257(k:WindowMouseEvent)
        {
            Logger.log(["Release clicked"]);
            this.trackAction("release");
            this._moderationManager.issueManager.releaseBundle(this._issueBundle.id);
            this._Str_13345();
            this.dispose();
        }

        function _Str_20796(k:WindowMouseEvent)
        {
            var _local_2:IssueMessageData = null;
            var _local_3 = 0;
            final _iter_ = this._issueBundle.issues; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2._Str_2869 == k.window.id)
                {
                    this._selectedIssue = _local_2;
                    _local_3 = _local_2._Str_19929;
                    if (_local_3 != 0)
                    {
                        if (this._callerUserInfo != null)
                        {
                            this._callerUserInfo.dispose();
                        }
                        this._callerUserInfo = new UserInfoCtrl(this._window, this._moderationManager, _local_2, this);
                        this._callerUserInfo.load(cast(this._window.findChildByName("caller_user_info"), IWindowContainer), _local_3);
                        this._moderationManager.connection.send(new GetCfhChatlogMessageComposer(_local_2._Str_2869));
                        this._chatLogCtrl.setId(_local_2._Str_2869);
                        this._moderationManager.moderationMessageHandler.addChatlogListener(this._chatLogCtrl);
                    }
                    break;
                }
            }
        }

        public function _Str_21978()
        {
            this._Str_21213();
            this._Str_21255();
        }

        public function _Str_13994(k:Int, _arg_2:String)
        {
            if (((((this._window == null) || (this._moderationManager == null)) || (this._moderationManager.issueManager == null)) || (this._issueBundle == null)))
            {
                return;
            }
            if (k != this._issueBundle.reportedUserId)
            {
                return;
            }
            var _local_3= Std.downcast(this._window.findChildByName("sanction_label") , ITextWindow);
            if (_local_3 != null)
            {
                _local_3.caption = _arg_2;
            }
        }

        function _Str_13345()
        {
            if ((((this._window == null) || (this._moderationManager == null)) || (this._moderationManager.issueManager == null)))
            {
                return;
            }
            var k= Std.downcast(this._window.findChildByName("handle_next_checkbox") , ICheckBoxWindow);
            if (((!(k == null)) && k.Selected))
            {
                this._moderationManager.issueManager.autoPick("issue handler pick next");
            }
        }

        @:allow(com.sulake.habbo.moderation) var _Str_22269(get,never):UserInfoCtrl;
function  get__Str_22269():UserInfoCtrl
        {
            return this._callerUserInfo;
        }

        @:allow(com.sulake.habbo.moderation) var _Str_25718(get,never):UserInfoCtrl;
function  get__Str_25718():UserInfoCtrl
        {
            return this._reportedUserInfo;
        }

        @:allow(com.sulake.habbo.moderation) function trackAction(k:String)
        {
            if (((this._moderationManager == null) || this._moderationManager.disposed))
            {
                return;
            }
            this._actionCount++;
            this._moderationManager.trackGoogle(("issueHandler_" + k));
        }
    }

