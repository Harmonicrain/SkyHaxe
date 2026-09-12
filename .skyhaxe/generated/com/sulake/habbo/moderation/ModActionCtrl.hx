package com.sulake.habbo.moderation
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.parser.moderation.IssueMessageData;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.incoming.callforhelp.CallForHelpCategoryData;
    import com.sulake.habbo.communication.messages.incoming.callforhelp.CallForHelpTopicData;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.moderator.DefaultSanctionMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.moderator.ModAlertMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.moderator.ModMuteMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.moderator.ModBanMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.moderator.ModKickMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.moderator.ModTradingLockMessageComposer;
    import com.sulake.habbo.utils.StringUtil;
    import com.sulake.habbo.communication.messages.outgoing.moderator.ModMessageMessageComposer;
    import com.sulake.habbo.window.utils.IAlertDialog;

     class ModActionCtrl implements IDisposable implements  ITrackedWindow 
    {
        static var _Str_3610:Array<ASAny>;
        static var _Str_8886:Map;

        var _Str_2327:ModerationManager;
        var _Str_4127:Int = 0;
        var _Str_7866:String;
        var _Str_3598:IssueMessageData;
        var _frame:IFrameWindow;
        var _Str_3643:IDropMenuWindow;
        var _Str_5384:Array<ASAny>;
        var _Str_8957:IDropMenuWindow;
        var _Str_3121:ITextFieldWindow;
        var _disposed:Bool = false;
        var _Str_9258:UserInfoCtrl;

        public function new(k:ModerationManager, _arg_2:Int, _arg_3:String, _arg_4:IssueMessageData, _arg_5:UserInfoCtrl)
        {
            this._Str_2327 = k;
            this._Str_4127 = _arg_2;
            this._Str_7866 = _arg_3;
            this._Str_3598 = _arg_4;
            this._Str_9258 = _arg_5;
            if (_Str_3610 == null)
            {
                _Str_3610 = new Array<ASAny>();
                _Str_3610.push(new ModActionDefinition(1, "Alert", ModActionDefinition.ALERT, 1, 0));
                _Str_3610.push(new ModActionDefinition(2, "Mute 1h", ModActionDefinition.MUTE, 2, 0));
                _Str_3610.push(new ModActionDefinition(3, "Ban 18h", ModActionDefinition.BAN, 3, 0));
                _Str_3610.push(new ModActionDefinition(4, "Ban 7 days", ModActionDefinition.BAN, 4, 0));
                _Str_3610.push(new ModActionDefinition(5, "Ban 30 days (step 1)", ModActionDefinition.BAN, 5, 0));
                _Str_3610.push(new ModActionDefinition(7, "Ban 30 days (step 2)", ModActionDefinition.BAN, 7, 0));
                _Str_3610.push(new ModActionDefinition(6, "Ban 100 years", ModActionDefinition.BAN, 6, 0));
                _Str_3610.push(new ModActionDefinition(106, "Ban avatar-only 100 years", ModActionDefinition.BAN, 6, 0));
                _Str_3610.push(new ModActionDefinition(101, "Kick", ModActionDefinition.KICK, 0, 0));
                _Str_3610.push(new ModActionDefinition(102, "Lock trade 1 week", ModActionDefinition.TRADING_LOCK, 0, 168));
                _Str_3610.push(new ModActionDefinition(104, "Lock trade permanent", ModActionDefinition.TRADING_LOCK, 0, 876000));
                _Str_3610.push(new ModActionDefinition(105, "Message", ModActionDefinition.MESSAGE, 0, 0));
            }
            this._Str_2327.issueManager._Str_24021(this._Str_4127, this);
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function show()
        {
            this._frame = cast(this._Str_2327.getXmlWindow("modact_summary"), IFrameWindow);
            this._frame.caption = ("Mod action on: " + this._Str_7866);
            this._frame.findChildByName("custom_sanction_button").procedure = this._Str_23444;
            this._Str_3121 = cast(this._frame.findChildByName("message_input"), ITextFieldWindow);
            this._frame.findChildByName("default_sanction_button").procedure = this._Str_23397;
            this._frame.findChildByName("default_sanction_button").disable();
            this._Str_25741();
            this._Str_17163();
            this._Str_24470();
            var k= this._frame.findChildByTag("close");
            k.procedure = this.onClose;
            this._frame.visible = true;
        }

        public function getType():Int
        {
            return WindowTracker._Str_18770;
        }

        public function getId():String
        {
            return this._Str_7866;
        }

        public function getFrame():IFrameWindow
        {
            return this._frame;
        }

        function logEvent(k:String, _arg_2:String="")
        {
            if (this._Str_9258 != null)
            {
                this._Str_9258.logEvent(k, _arg_2);
            }
        }

        function trackAction(k:String)
        {
            if (((!(this._Str_9258 == null)) && (!this._Str_9258.disposed)))
            {
                this._Str_9258.trackAction(("modAction_" + k));
            }
        }

        function _Str_25741()
        {
            var k:String = null;
            var _local_2:Array<ASAny> = null;
            var _local_3 = 0;
            var _local_4:Array<ASAny> = null;
            var _local_5 = 0;
            var _local_6 = 0;
            if (_Str_8886 == null)
            {
                _Str_8886 = new Map();
                k = this._Str_2327.getProperty("cfh.topic_id.to.sanction_type_id");
                if (k != null)
                {
                    _local_2 = (cast k.split(","));
                    _local_3 = 0;
                    while (_local_3 < _local_2.length)
                    {
                        _local_4 = _local_2[_local_3].split("=");
                        if (_local_4.length == 2)
                        {
                            _local_5 = ASCompat.parseInt(ASCompat.toString(_local_4[0]));
                            _local_6 = ASCompat.parseInt(ASCompat.toString(_local_4[1]));
                            _Str_8886.add(_local_5, _local_6);
                        }
                        _local_3++;
                    }
                }
            }
        }

        function _Str_17163()
        {
            var _local_3:CallForHelpCategoryData = null;
            var _local_4:CallForHelpTopicData = null;
            this._Str_3643 = cast(this._frame.findChildByName("cfh_topics"), IDropMenuWindow);
            this._Str_3643.addEventListener(WindowEvent.WINDOW_EVENT_SELECTED, this._Str_17950);
            this._Str_5384 = [];
            var k:Array<ASAny> = [];
            var _local_2 = 0;
            final _iter_ = this._Str_2327.issueManager.getCfhTopics(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                final _iter_ = _local_3._Str_14841; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_4  = _tmp_;
                    k[_local_2] = (("${help.cfh.topic." + Std.string(_local_4.id)) + "}");
                    this._Str_5384[_local_2] = _local_4.id;
                    _local_2++;
                }
            }
            this._Str_3643.populate(k);
        }

        function _Str_17950(k:WindowEvent)
        {
            var _local_5 = 0;
            var _local_2= this._Str_3643.selection;
            var _local_3= ASCompat.toInt(this._Str_5384[_local_2]);
            var _local_4= ASCompat.toInt(_Str_8886.getValue(_local_3));
            if (_local_4 == 0)
            {
                _local_4 = ASCompat.toInt(_Str_8886.getValue(0));
            }
            if (_local_4 != 0)
            {
                _local_5 = 0;
                while (_local_5 < _Str_3610.length)
                {
                    if (_Str_3610[_local_5].actionId == _local_4)
                    {
                        this._Str_8957.selection = _local_5;
                        break;
                    }
                    _local_5++;
                }
            }
            else
            {
                this._Str_8957.selection = -1;
            }
            this._Str_2327.issueManager.requestSanctionDataForAccount(this._Str_4127, _local_3);
        }

        public function _Str_13994(k:Int, _arg_2:String)
        {
            if (((this._frame == null) || (!(k == this._Str_4127))))
            {
                return;
            }
            var _local_3= Std.downcast(this._frame.findChildByName("default_sanction_label") , ITextWindow);
            if (_local_3 != null)
            {
                _local_3.caption = _arg_2;
            }
            this._frame.findChildByName("default_sanction_button").enable();
        }

        function _Str_24470()
        {
            var _local_2:ModActionDefinition = null;
            this._Str_8957 = cast(this._frame.findChildByName("sanction_type"), IDropMenuWindow);
            var k:Array<ASAny> = [];
            final _iter_ = _Str_3610; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                k.push(_local_2.name);
            }
            this._Str_8957.populate(k);
        }

        function _Str_23397(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if (this._Str_3643.selection < 0)
            {
                this._Str_2327.windowManager.alert("Alert", "Please select a topic.", 0, this.onAlertClose);
                return;
            }
            Logger.log(["Giving default sanction..."]);
            this.trackAction("defaultAction");
            this.logEvent("action.default");
            var _local_3= ASCompat.toInt(this._Str_5384[this._Str_3643.selection]);
            this._Str_2327.connection.send(new DefaultSanctionMessageComposer(this._Str_4127, _local_3, this._Str_3121.text, this._Str_7121()));
            this.dispose();
        }

        function _Str_23444(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_4:ModActionDefinition = null;
            var _local_5 = false;
            var _local_6 = 0;
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if (this._Str_3643.selection < 0)
            {
                this._Str_2327.windowManager.alert("Alert", "Please select a topic.", 0, this.onAlertClose);
                return;
            }
            if (this._Str_8957.selection < 0)
            {
                this._Str_2327.windowManager.alert("Alert", "Please select a sanction.", 0, this.onAlertClose);
                return;
            }
            var _local_3= ASCompat.toInt(this._Str_5384[this._Str_3643.selection]);
            _local_4 = _Str_3610[this._Str_8957.selection];
            switch (_local_4.actionType)
            {
                case ModActionDefinition.ALERT:
                    if (!this._Str_2327.initMsg._Str_18465)
                    {
                        this._Str_2327.windowManager.alert("Alert", "You have insufficient permissions.", 0, this.onAlertClose);
                        return;
                    }
                    this.trackAction("sendCaution");
                    this._Str_2327.connection.send(new ModAlertMessageComposer(this._Str_4127, this._Str_3121.text, _local_3, this._Str_7121()));
                    
                case ModActionDefinition.MUTE:
                    this.trackAction("mute");
                    this._Str_2327.connection.send(new ModMuteMessageComposer(this._Str_4127, this._Str_3121.text, _local_3, this._Str_7121()));
                    
                case ModActionDefinition.BAN:
                    if (!this._Str_2327.initMsg._Str_21242)
                    {
                        this._Str_2327.windowManager.alert("Alert", "You have insufficient permissions.", 0, this.onAlertClose);
                        return;
                    }
                    this.trackAction("ban");
                    _local_5 = (_local_4.actionId == 106);
                    this._Str_2327.connection.send(new ModBanMessageComposer(this._Str_4127, this._Str_3121.text, _local_3, _local_4._Str_22995, _local_5, this._Str_7121()));
                    
                case ModActionDefinition.KICK:
                    if (!this._Str_2327.initMsg._Str_20397)
                    {
                        this._Str_2327.windowManager.alert("Alert", "You have insufficient permissions.", 0, this.onAlertClose);
                        return;
                    }
                    this.trackAction("kick");
                    this._Str_2327.connection.send(new ModKickMessageComposer(this._Str_4127, this._Str_3121.text, _local_3, this._Str_7121()));
                    
                case ModActionDefinition.TRADING_LOCK:
                    this.trackAction("trading_lock");
                    _local_6 = (_local_4._Str_25670 * 60);
                    this._Str_2327.connection.send(new ModTradingLockMessageComposer(this._Str_4127, this._Str_3121.text, _local_6, _local_3, this._Str_7121()));
                    
                case ModActionDefinition.MESSAGE:
                    if (StringUtil.isEmpty(this._Str_3121.text))
                    {
                        this._Str_2327.windowManager.alert("Alert", "Please write a message to user.", 0, this.onAlertClose);
                        return;
                    }
                    this.trackAction("sendCaution");
                    this._Str_2327.connection.send(new ModMessageMessageComposer(this._Str_4127, this._Str_3121.text, _local_3, this._Str_7121()));
                    
            }
            this.logEvent("action.custom", "unknown");
            this.dispose();
        }

        function onClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.trackAction("close");
            this.dispose();
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            if (this._frame != null)
            {
                this._frame.destroy();
                this._frame = null;
            }
            this._Str_3643 = null;
            this._Str_3121 = null;
            this._Str_2327.issueManager._Str_23349(this._Str_4127);
            this._Str_2327 = null;
        }

        function onAlertClose(k:IAlertDialog, _arg_2:WindowEvent)
        {
            k.dispose();
        }

        function _Str_7121():Int
        {
            return (this._Str_3598 != null) ? this._Str_3598._Str_2869 : ModBanMessageComposer.NO_ISSUE_ID;
        }
    }

