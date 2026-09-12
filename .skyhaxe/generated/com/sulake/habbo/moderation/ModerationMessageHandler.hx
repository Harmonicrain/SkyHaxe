package com.sulake.habbo.moderation
;
    import com.sulake.habbo.communication.messages.incoming.moderation.IssueInfoMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.moderation.ModeratorInitMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.moderation.ModeratorToolPreferencesEvent;
    import com.sulake.habbo.communication.messages.incoming.moderation.IssuePickFailedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.moderation.IssueDeletedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.moderation.ModeratorUserInfoEvent;
    import com.sulake.habbo.communication.messages.incoming.moderation.ModeratorRoomInfoEvent;
    import com.sulake.habbo.communication.messages.incoming.moderation.CfhChatlogEvent;
    import com.sulake.habbo.communication.messages.incoming.moderation.UserChatlogEvent;
    import com.sulake.habbo.communication.messages.incoming.moderation.RoomChatlogEvent;
    import com.sulake.habbo.communication.messages.incoming.moderation.RoomVisitsEvent;
    import com.sulake.habbo.communication.messages.incoming.room.engine.RoomEntryInfoMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.room.session.CloseConnectionMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.moderation.ModeratorActionResultMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.userclassification.UserClassificationMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.callforhelp.CfhSanctionMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.callforhelp.CfhTopicsInitEvent;
    import com.sulake.habbo.communication.messages.parser.moderation.IssueMessageData;
    import com.sulake.habbo.communication.messages.parser.moderation.ModeratorToolPreferencesMessageParser;
    import com.sulake.habbo.window.utils.IAlertDialog;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.userclassification.UserClassificationData;
    import com.sulake.habbo.communication.messages.incoming.callforhelp.CallForHelpCategoryData;
    import com.sulake.habbo.communication.messages.outgoing.moderator.GetModeratorUserInfoMessageComposer;
    import com.sulake.habbo.communication.messages.incoming.moderation.*;
    import com.sulake.habbo.communication.messages.parser.moderation.*;

     class ModerationMessageHandler 
    {
        var _moderationManager:ModerationManager;
        var _userInfoListeners:Array<ASAny>;
        var _roomVisitsListeners:Array<ASAny>;
        var _userClassificationListener:Array<ASAny>;
        var _chatlogListeners:Array<ASAny>;
        var _roomInfoListeners:Array<ASAny>;
        var _roomEnterListeners:Array<ASAny>;

        public function new(k:ModerationManager)
        {
            this._userInfoListeners = new Array<ASAny>();
            this._roomVisitsListeners = new Array<ASAny>();
            this._userClassificationListener = new Array<ASAny>();
            this._chatlogListeners = new Array<ASAny>();
            this._roomInfoListeners = new Array<ASAny>();
            this._roomEnterListeners = new Array<ASAny>();
            this._moderationManager = k;
            var _local_2= k.connection;
            _local_2.addMessageEvent(new IssueInfoMessageEvent(this.onIssueInfo));
            _local_2.addMessageEvent(new ModeratorInitMessageEvent(this.onModeratorInit));
            _local_2.addMessageEvent(new ModeratorToolPreferencesEvent(this.onModeratorToolPreferences));
            _local_2.addMessageEvent(new IssuePickFailedMessageEvent(this.onIssuePickFailed));
            _local_2.addMessageEvent(new IssueDeletedMessageEvent(this.onIssueDeleted));
            _local_2.addMessageEvent(new ModeratorUserInfoEvent(this.onUserInfo));
            _local_2.addMessageEvent(new ModeratorRoomInfoEvent(this.onRoomInfo));
            _local_2.addMessageEvent(new CfhChatlogEvent(this.onCfhChatlog));
            _local_2.addMessageEvent(new UserChatlogEvent(this.onUserChatlog));
            _local_2.addMessageEvent(new RoomChatlogEvent(this.onRoomChatlog));
            _local_2.addMessageEvent(new RoomVisitsEvent(this.onRoomVisits));
            _local_2.addMessageEvent(new RoomEntryInfoMessageEvent(this.onRoomEnter));
            _local_2.addMessageEvent(new CloseConnectionMessageEvent(this.onRoomExit));
            _local_2.addMessageEvent(new ModeratorActionResultMessageEvent(this.onModeratorActionResult));
            _local_2.addMessageEvent(new UserClassificationMessageEvent(this.onRoomUserClassification));
            _local_2.addMessageEvent(new CfhSanctionMessageEvent(this.onSanctions));
            _local_2.addMessageEvent(new CfhTopicsInitEvent(this.onCfhTopics));
        }

        function onIssueInfo(k:IssueInfoMessageEvent)
        {
            if (((k == null) || (this._moderationManager == null)))
            {
                return;
            }
            var _local_2= k.getParser();
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= _local_2._Str_22192;
            this._moderationManager.issueManager.playSound(_local_3);
            this._moderationManager.issueManager.addModActionView(_local_3);
        }

        function onModeratorInit(k:ModeratorInitMessageEvent)
        {
            var _local_6:IssueMessageData = null;
            if (((k == null) || (this._moderationManager == null)))
            {
                return;
            }
            var _local_2= k.getParser();
            if (((_local_2 == null) || (_local_2.data == null)))
            {
                return;
            }
            var _local_3= _local_2.data;
            var _local_4= _local_3.issues;
            var _local_5= _local_3._Str_15690;
            if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
            {
_local_6  = _tmp_;
                this._moderationManager.issueManager.addModActionView(_local_6);
            }
            this._moderationManager.issueManager._Str_19194();
            this._moderationManager.initMsg = _local_3;
        }

        function onModeratorToolPreferences(k:ModeratorToolPreferencesEvent)
        {
            var _local_2:ModeratorToolPreferencesMessageParser = null;
            if (((this._moderationManager != null) && (this._moderationManager.issueManager != null)))
            {
                _local_2 = k.getParser();
                this._moderationManager.issueManager.setToolPreferences(_local_2._Str_17736, _local_2._Str_18137, _local_2._Str_17903, _local_2._Str_4971);
            }
        }

        function onIssuePickFailed(event:IssuePickFailedMessageEvent)
        {
            var parser= event.getParser();
            if (parser == null)
            {
                return;
            }
            var alert= true;
            var issues= parser.issues;
            var retryEnabled= parser.retryEnabled;
            var retryCount= parser.retryCount;
            var pickedAlready= this._moderationManager.issueManager.issuePickFailed(issues);
            if (pickedAlready)
            {
                if (retryEnabled)
                {
                    if (retryCount < 10)
                    {
                        alert = false;
                        this._moderationManager.issueManager.autoPick("pick failed retry", retryEnabled, retryCount);
                    }
                }
            }
            if (alert)
            {
                this._moderationManager.windowManager.alert("Error", "Issue picking failed", 0, function (k:IAlertDialog, _arg_2:WindowEvent)
                {
                    k.dispose();
                });
            }
        }

        function onIssueDeleted(k:IssueDeletedMessageEvent)
        {
            if (((k == null) || (this._moderationManager == null)))
            {
                return;
            }
            var _local_2= k.getParser();
            if (_local_2 == null)
            {
                return;
            }
            this._moderationManager.issueManager.removeIssue(_local_2._Str_2869);
        }

        function onUserInfo(k:ModeratorUserInfoEvent)
        {
            var _local_3:IUserInfoListener = null;
            var _local_2= k.getParser();
            Logger.log([((("GOT USER INFO: " + Std.string(_local_2.data.userId)) + ", ") + Std.string(_local_2.data._Str_16987))]);
            final _iter_ = this._userInfoListeners; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_3.onUserInfo(_local_2.data);
            }
        }

        function onRoomInfo(k:ModeratorRoomInfoEvent)
        {
            var _local_3:RoomToolCtrl = null;
            var _local_2= k.getParser();
            final _iter_ = this._roomInfoListeners; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_3.onRoomInfo(_local_2.data);
            }
        }

        function onCfhChatlog(k:CfhChatlogEvent)
        {
            var _local_2= k.getParser();
            var _local_3= new Array<ASAny>();
            _local_3.push(_local_2.data._Str_17106);
            var _local_4= new ASDictionary<ASAny,ASAny>();
            _local_4[_local_2.data._Str_23592] = 0;
            _local_4[_local_2.data.reportedUserId] = 1;
            this.onChatlog(("Call For Help Evidence #" + Std.string(_local_2.data._Str_20325)), WindowTracker._Str_15411, _local_2.data.callId, _local_3, _local_4);
        }

        function onRoomChatlog(k:RoomChatlogEvent)
        {
            var _local_2= k.getParser();
            var _local_3= new Array<ASAny>();
            _local_3.push(_local_2.data);
            var _local_4= new ASDictionary<ASAny,ASAny>();
            this.onChatlog(("Room Chatlog: " + _local_2.data.roomName), WindowTracker._Str_10414, _local_2.data.roomId, _local_3, _local_4);
        }

        function onUserChatlog(k:UserChatlogEvent)
        {
            var _local_2= k.getParser();
            var _local_3= new ASDictionary<ASAny,ASAny>();
            _local_3[_local_2.data.userId] = 0;
            this.onChatlog(("User Chatlog: " + _local_2.data.userName), WindowTracker._Str_15435, _local_2.data.userId, _local_2.data.rooms, _local_3);
        }

        function onChatlog(k:String, _arg_2:Int, _arg_3:Int, _arg_4:Array<ASAny>, _arg_5:ASDictionary<ASAny,ASAny>)
        {
            var _local_7:IChatLogListener = null;
            var _local_6= this._chatlogListeners.copy();
            if (checkNullIteratee(_local_6)) for (_tmp_ in _local_6)
            {
_local_7  = _tmp_;
                _local_7.onChatlog(k, _arg_2, _arg_3, _arg_4, _arg_5);
            }
        }

        function onRoomVisits(k:RoomVisitsEvent)
        {
            var _local_3:RoomVisitsCtrl = null;
            var _local_2= k.getParser();
            var _local_4= this._roomVisitsListeners.copy();
            if (checkNullIteratee(_local_4)) for (_tmp_ in _local_4)
            {
_local_3  = _tmp_;
                _local_3.onRoomVisits(_local_2.data);
            }
        }

        function onRoomUserClassification(k:UserClassificationMessageEvent)
        {
            var _local_3:UserClassificationCtrl = null;
            var _local_8 = 0;
            var _local_9:UserClassificationCtrl = null;
            var _local_10:Array<ASAny> = null;
            var _local_2= k .getParser();
            var _local_4= _local_2.classifiedUsernameMap;
            var _local_5= _local_2.classifiedUserTypeMap;
            var _local_6= 1;
            var _local_7= new Array<ASAny>();
            final _iter_ = _local_4.getKeys(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_8  = ASCompat.toInt(_tmp_);
                _local_7.push(new UserClassificationData(_local_8, _local_4.getValue(_local_8), _local_5.getValue(_local_8)));
            }
            _local_9 = new UserClassificationCtrl(this._moderationManager, _local_6);
            _local_9.show();
            _local_10 = this._userClassificationListener.copy();
            if (checkNullIteratee(_local_10)) for (_tmp_ in _local_10)
            {
_local_3  = _tmp_;
                _local_3._Str_22627(_local_6, _local_7);
            }
        }

        function onSanctions(k:CfhSanctionMessageEvent)
        {
            var _local_2= k.getParser();
            Logger.log([("Got sanction data..." + ASCompat.toString([_local_2._Str_2869, _local_2.accountId, _local_2._Str_21198]))]);
            this._moderationManager.issueManager.updateSanctionData(_local_2._Str_2869, _local_2.accountId, _local_2._Str_21198);
        }

        function onCfhTopics(k:CfhTopicsInitEvent)
        {
            var _local_3:Vector<CallForHelpCategoryData> = null;
            var _local_2= k.getParser();
            _local_3 = _local_2.callForHelpCategories;
            this._moderationManager.cfhTopics = _local_3;
        }

        function onRoomEnter(k:RoomEntryInfoMessageEvent)
        {
            var _local_3:RoomToolCtrl = null;
            var _local_2= k.getParser();
            this._moderationManager.currentFlatId = _local_2.guestRoomId;
            this._moderationManager.startPanel._Str_25175(_local_2);
            final _iter_ = this._roomEnterListeners; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_3.onRoomChange();
            }
        }

        function onRoomExit(k:CloseConnectionMessageEvent)
        {
            var _local_2:RoomToolCtrl = null;
            this._moderationManager.currentFlatId = 0;
            this._moderationManager.startPanel._Str_25510();
            final _iter_ = this._roomEnterListeners; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_2.onRoomChange();
            }
        }

        function onModeratorActionResult(k:ModeratorActionResultMessageEvent)
        {
            var _local_2= k.getParser();
            Logger.log([((("GOT MOD ACTION RESULT: " + Std.string(_local_2.userId)) + ", ") + Std.string(_local_2.success))]);
            if (_local_2.success)
            {
                this._moderationManager.connection.send(new GetModeratorUserInfoMessageComposer(_local_2.userId));
            }
            else
            {
                this._moderationManager.windowManager.alert("Alert", ("Moderation action failed. " + "If you tried to ban a user, please check if the user is already banned."), 0, this.onAlertClose);
            }
        }

        public function addUserInfoListener(k:IUserInfoListener)
        {
            this._userInfoListeners.push(k);
        }

        public function removeUserInfoListener(k:IUserInfoListener)
        {
            var _local_3:IUserInfoListener = null;
            var _local_2= new Array<ASAny>();
            final _iter_ = this._userInfoListeners; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (_local_3 != k)
                {
                    _local_2.push(_local_3);
                }
            }
            this._userInfoListeners = _local_2;
        }

        public function addRoomInfoListener(k:RoomToolCtrl)
        {
            this._roomInfoListeners.push(k);
        }

        public function removeRoomInfoListener(k:RoomToolCtrl)
        {
            var _local_3:RoomToolCtrl = null;
            var _local_2= new Array<ASAny>();
            final _iter_ = this._roomInfoListeners; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (_local_3 != k)
                {
                    _local_2.push(_local_3);
                }
            }
            this._roomInfoListeners = _local_2;
        }

        public function addRoomEnterListener(k:RoomToolCtrl)
        {
            this._roomEnterListeners.push(k);
        }

        public function removeRoomEnterListener(k:RoomToolCtrl)
        {
            var _local_3:RoomToolCtrl = null;
            var _local_2= new Array<ASAny>();
            final _iter_ = this._roomEnterListeners; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (_local_3 != k)
                {
                    _local_2.push(_local_3);
                }
            }
            this._roomEnterListeners = _local_2;
        }

        public function addRoomVisitsListener(k:RoomVisitsCtrl)
        {
            this._roomVisitsListeners.push(k);
        }

        public function removeRoomVisitsListener(k:RoomVisitsCtrl)
        {
            var _local_3:RoomVisitsCtrl = null;
            var _local_2= new Array<ASAny>();
            final _iter_ = this._roomVisitsListeners; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (_local_3 != k)
                {
                    _local_2.push(_local_3);
                }
            }
            this._roomVisitsListeners = _local_2;
        }

        public function addChatlogListener(k:IChatLogListener)
        {
            this._chatlogListeners.push(k);
        }

        public function removeChatlogListener(k:IChatLogListener)
        {
            var _local_3:IChatLogListener = null;
            var _local_2= new Array<ASAny>();
            final _iter_ = this._chatlogListeners; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (_local_3 != k)
                {
                    _local_2.push(_local_3);
                }
            }
            this._chatlogListeners = _local_2;
        }

        public function addUserClassificationListener(k:UserClassificationCtrl)
        {
            this._userClassificationListener.push(k);
        }

        public function removeUserClassificationListener(k:UserClassificationCtrl)
        {
            var _local_3:UserClassificationCtrl = null;
            var _local_2= new Array<ASAny>();
            final _iter_ = this._userClassificationListener; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                if (_local_3 != k)
                {
                    _local_2.push(_local_3);
                }
            }
            this._userClassificationListener = _local_2;
        }

        function onAlertClose(k:IAlertDialog, _arg_2:WindowEvent)
        {
            k.dispose();
        }
    }

