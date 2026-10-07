package com.sulake.habbo.moderation
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.communication.messages.parser.moderation.IssueMessageData;
    import com.sulake.habbo.communication.messages.incoming.moderation.ModeratorUserInfoData;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.outgoing.moderator.GetModeratorUserInfoMessageComposer;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.moderator.GetUserChatlogMessageComposer;
    import com.sulake.core.window.events.WindowEvent;

     class UserInfoCtrl implements IDisposable implements  IUserInfoListener 
    {
        static inline final _Str_12631= 60;
        static final _Str_12954:Int = (60 * 60);//3600
        static final _Str_13366:Int = ((60 * 60) * 24);//86400
        static final _Str_15239:Int = (((60 * 60) * 24) * 365);//31536000

        var _callerFrame:IFrameWindow;
        var _main:ModerationManager;
        var _userId:Int = 0;
        var _issue:IssueMessageData;
        var _data:ModeratorUserInfoData;
        var _father:IWindowContainer;
        var _openToolsBelow:Bool = false;
        var _disposed:Bool = false;
        var _issueHandler:IssueHandler;

        public function new(k:IFrameWindow, _arg_2:ModerationManager, _arg_3:IssueMessageData, _arg_4:IssueHandler=null, _arg_5:Bool=false)
        {
            this._callerFrame = k;
            this._main = _arg_2;
            this._issue = _arg_3;
            this._openToolsBelow = _arg_5;
            this._issueHandler = _arg_4;
        }

        public static function _Str_12797(k:Int):String
        {
            if (k < (2 * _Str_12631))
            {
                return Std.string(k) + " secs ago";
            }
            if (k < (2 * _Str_12954))
            {
                return Std.string(Math.fround((k / _Str_12631))) + " mins ago";
            }
            if (k < (2 * _Str_13366))
            {
                return Std.string(Math.fround((k / _Str_12954))) + " hours ago";
            }
            if (k < (2 * _Str_15239))
            {
                return Std.string(Math.fround((k / _Str_13366))) + " days ago";
            }
            return Std.string(Math.fround((k / _Str_15239))) + " years ago";
        }


        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function load(k:IWindowContainer, _arg_2:Int)
        {
            this._father = k;
            this._userId = _arg_2;
            this._data = null;
            this.refresh();
            this._main.moderationMessageHandler.addUserInfoListener(this);
            this._main.connection.send(new GetModeratorUserInfoMessageComposer(_arg_2));
        }

        public function onUserInfo(k:ModeratorUserInfoData)
        {
            if (k.userId != this._userId)
            {
                return;
            }
            this._data = k;
            this.refresh();
        }

        public function refresh()
        {
            if (this._father.disposed)
            {
                return;
            }
            var k= this.prepare();
            if (this._data == null)
            {
                k.findChildByName("fields").visible = false;
                k.findChildByName("loading_txt").visible = true;
                return;
            }
            k.findChildByName("fields").visible = true;
            k.findChildByName("loading_txt").visible = false;
            this.setTxt(k, "name_txt", this._data.userName);
            this.setTxt(k, "registered_txt", _Str_12797((this._data._Str_24334 * 60)));
            this.setTxt(k, "cfh_count_txt", ("" + Std.string(this._data._Str_24656)));
            this._Str_13036(k, "abusive_cfh_count_txt", this._data._Str_22987);
            this._Str_13036(k, "caution_count_txt", this._data._Str_16987);
            this._Str_13036(k, "ban_count_txt", this._data._Str_20373);
            this._Str_13036(k, "trading_lock_count_txt", this._data._Str_24526);
            this.setTxt(k, "trading_lock_expiry_txt", this._data._Str_23969, "No active lock");
            this.setTxt(k, "last_login_txt", _Str_12797((this._data._Str_23276 * 60)));
            this.setTxt(k, "online_txt", (this._data.online ? "Yes" : "No"));
            this.setTxt(k, "last_purchase_txt", this._data._Str_22786, "No purchases");
            this.setTxt(k, "email_address_txt", this._data._Str_20219, "No email found");
            this.setTxt(k, "id_bans_txt", ("" + Std.string(this._data._Str_22700)));
            this.setTxt(k, "user_class_txt", this._data._Str_22262, "-");
            this.setTxt(k, "last_sanction_time_txt", this._data._Str_24447);
            if (this._data._Str_19137 <= 48)
            {
                Std.downcast(k.findChildByName("last_sanction_time_txt") , ITextWindow).textColor = (Std.int((0xFF * (48 - this._data._Str_19137)) / 48) << 16);
            }
            if (this._data._Str_20219 == "No identity")
            {
                k.findChildByName("modaction_but").disable();
            }
            Logger.log([((((("USER: " + this._data.userName) + ", ") + Std.string(this._data._Str_20373)) + ", ") + Std.string(this._data._Str_16987))]);
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            this._main.moderationMessageHandler.removeUserInfoListener(this);
            this._callerFrame = null;
            this._main = null;
            this._data = null;
            this._father = null;
        }

        function prepare():IWindowContainer
        {
            var k= cast(this._father.findChildByName("user_info"), IWindowContainer);
            if (k == null)
            {
                k = cast(this._main.getXmlWindow("user_info"), IWindowContainer);
                this._father.addChild(k);
                if (!this._main.initMsg._Str_12765)
                {
                    k.findChildByName("chatlog_but").disable();
                }
                if (!this._main.initMsg._Str_18465)
                {
                    k.findChildByName("message_but").disable();
                }
                if (!((this._main.initMsg._Str_18465 || this._main.initMsg._Str_20397) || this._main.initMsg._Str_21242))
                {
                    k.findChildByName("modaction_but").disable();
                }
            }
            k.findChildByName("chatlog_but").procedure = this._Str_16926;
            k.findChildByName("roomvisits_but").procedure = this._Str_24240;
            k.findChildByName("habboinfotool_but").procedure = this._Str_24702;
            k.findChildByName("message_but").procedure = this._Str_24767;
            k.findChildByName("modaction_but").procedure = this._Str_25818;
            k.findChildByName("view_caution_count_txt").procedure = this._Str_24733;
            k.findChildByName("view_ban_count_txt").procedure = this._Str_23167;
            k.findChildByName("view_trading_lock_count_txt").procedure = this._Str_24564;
            k.findChildByName("view_id_bans_txt").procedure = this._Str_22795;
            return k;
        }

        function _Str_13036(k:IWindowContainer, _arg_2:String, _arg_3:Int)
        {
            var _local_4= k.findChildByName(_arg_2);
            var _local_5= k.findChildByName(("view_" + _arg_2));
            if (_local_5 != null)
            {
                _local_5.visible = (_arg_3 > 0);
            }
            _local_4.caption = ("" + Std.string(_arg_3));
        }

        function setTxt(k:IWindowContainer, _arg_2:String, _arg_3:String, _arg_4:String="")
        {
            var _local_5:IWindow = cast(k.findChildByName(_arg_2), ITextWindow);
            if (((!ASCompat.stringAsBool(_arg_3)) || (_arg_3.length == 0)))
            {
                _local_5.caption = _arg_4;
            }
            else
            {
                _local_5.caption = _arg_3;
            }
        }

        function _Str_16926(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.trackAction("chatLog");
            this._main.windowTracker.show(new ChatlogCtrl(new GetUserChatlogMessageComposer(this._data.userId), this._main, WindowTracker._Str_15435, this._data.userId), this._callerFrame, this._openToolsBelow, false, true);
        }

        function _Str_24240(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._main.windowTracker.show(new RoomVisitsCtrl(this._main, this._data.userId), this._callerFrame, this._openToolsBelow, false, true);
        }

        function _Str_24702(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.trackAction("openInfoTool");
            this._main.openHkPage("habboinfotool.url", this._data.userName);
        }

        function _Str_24767(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.trackAction("openSendMessage");
            this._main.windowTracker.show(new SendMsgsCtrl(this._main, this._data.userId, this._data.userName, this._issue), this._callerFrame, this._openToolsBelow, false, true);
        }

        function _Str_25818(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.trackAction("openModAction");
            this._main.windowTracker.show(new ModActionCtrl(this._main, this._data.userId, this._data.userName, this._issue, this), this._callerFrame, this._openToolsBelow, false, true);
        }

        function _Str_24733(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.trackAction("viewCautions");
            this._Str_17807();
        }

        function _Str_23167(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.trackAction("viewBans");
            this._Str_17807();
        }

        function _Str_24564(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.trackAction("viewTradingLocks");
            this._Str_17807();
        }

        function _Str_22795(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.trackAction("viewIdentityInfo");
            this._Str_25391();
        }

        function _Str_17807()
        {
            this._main.openHkPage("moderatoractionlog.url", this._data.userName);
        }

        function _Str_25391()
        {
            this._main.openHkPage("identityinformationtool.url", ("" + Std.string(this._data._Str_25657)));
        }

        @:allow(com.sulake.habbo.moderation) function logEvent(k:String, _arg_2:String)
        {
            if (this._main != null)
            {
                this._main.logEvent(k, _arg_2);
            }
        }

        @:allow(com.sulake.habbo.moderation) function trackAction(k:String)
        {
            if (((this._issueHandler == null) || this._issueHandler.disposed))
            {
                this._main.trackGoogle(("userInfo_" + k));
            }
            else
            {
                if (this == this._issueHandler._Str_22269)
                {
                    this._issueHandler.trackAction(("callerUserInfo_" + k));
                }
                else
                {
                    if (this == this._issueHandler._Str_25718)
                    {
                        this._issueHandler.trackAction(("reportedUserInfo_" + k));
                    }
                    else
                    {
                        this._issueHandler.trackAction(("userInfo_" + k));
                    }
                }
            }
        }
    }

