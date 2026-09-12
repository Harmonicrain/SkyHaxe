package com.sulake.habbo.help.guidehelp
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.window.widgets.IIlluminaInputHandler;
    import com.sulake.habbo.help.HabboHelp;
    import com.sulake.habbo.help.GuideHelpManager;
    import com.sulake.core.window.IWindowContainer;
    import flash.geom.Point;
    import com.sulake.core.window.components.IWidgetWindow;
    import flash.utils.Timer;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import com.sulake.habbo.communication.messages.incoming.help.GuideSessionAttachedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.GuideSessionDetachedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.GuideSessionStartedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.GuideSessionEndedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.GuideSessionErrorMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.GuideSessionMessageMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.GuideSessionRequesterRoomMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.GuideSessionInvitedToGuideRoomMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.GuideSessionPartnerIsTypingMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.perk.PerkAllowancesEvent;
    import com.sulake.habbo.communication.messages.incoming.help.GuideOnDutyStatusMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.ChatReviewSessionOfferedToGuideMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.ChatReviewSessionStartedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.ChatReviewSessionVotingStatusMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.ChatReviewSessionResultsMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.help.ChatReviewSessionDetachedMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.ChatReviewSessionVotingStatusMessageParser;
    import com.sulake.habbo.help._enum._Str_2849;
    import com.sulake.habbo.help._enum.GuideSessionStateEnum;
    import com.sulake.habbo.communication.messages.outgoing.help.GuideSessionCreateMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.help.GuideSessionOnDutyUpdateMessageComposer;
    import com.sulake.habbo.communication.messages.parser.help.GuideSessionAttachedMessageParser;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.GuideSessionStartedMessageParser;
    import com.sulake.habbo.communication.messages.parser.help.GuideSessionEndedMessageParser;
    import com.sulake.habbo.communication.messages.parser.help.GuideSessionErrorMessageParser;
    import com.sulake.habbo.communication.messages.parser.help.GuideSessionMessageMessageParser;
    import com.sulake.habbo.communication.messages.parser.help.GuideSessionRequesterRoomMessageParser;
    import com.sulake.habbo.communication.messages.parser.help.GuideSessionInvitedToGuideRoomMessageParser;
    import com.sulake.habbo.communication.messages.parser.perk.PerkAllowancesMessageParser;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.users.GetHabboGroupDetailsMessageComposer;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.session.talent.TalentEnum;
    import com.sulake.habbo.communication.messages.outgoing.talent.GetTalentTrackMessageComposer;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.sound.HabboSoundTypesEnum;
    import com.sulake.habbo.window.widgets.ICountdownWidget;
    import com.sulake.habbo.communication.messages.outgoing.help.GuideSessionGuideDecidesMessageComposer;
    import com.sulake.habbo.window.widgets.IIlluminaInputWidget;
    import com.sulake.habbo.communication.messages.outgoing.help.GuideSessionGetRequesterRoomMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.help.GuideSessionInviteRequesterMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.help.GuideSessionResolvedMessageComposer;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.habbo.communication.messages.outgoing.help.GuideSessionFeedbackMessageComposer;
    import mx.utils.StringUtil;
    import com.sulake.habbo.utils.FriendlyTime;
    import com.sulake.habbo.communication.messages.outgoing.help.GuideSessionRequesterCancelsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.GetExtendedProfileMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.help.ChatReviewGuideDecidesOnOfferMessageComposer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.communication.messages.outgoing.help.ChatReviewGuideDetachedMessageComposer;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.habbo.communication.messages.outgoing.help.ChatReviewGuideVoteMessageComposer;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.communication.messages.outgoing.help.GuideSessionReportMessageComposer;
    import com.sulake.habbo.window.widgets.IIlluminaChatBubbleWidget;
    import com.sulake.core.window._enum.WindowParam;
    import com.sulake.habbo.communication.messages.outgoing.help.GuideSessionMessageMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.help.GuideSessionIsTypingMessageComposer;

     class GuideSessionController implements IDisposable implements  IIlluminaInputHandler
    {
        static inline final _Str_12638= 0;
        static inline final _Str_14376= 1;
        static inline final _Str_13767= 2;
        static inline final _Str_13522= 0;
        static inline final _Str_13205= 1;
        static inline final _Str_7012= 2;
        static inline final _Str_17188= -1;
        static inline final _Str_10084= 0;
        static inline final _Str_9791= 1;
        static inline final _Str_10906= 2;
        static inline final _Str_18329= 3000;
        static inline final _Str_16534= 500;
        static final _Str_6777:Array<ASAny> = ["waiting", "ok", "bad", "very_bad", "refused", "searching"];
        static final _Str_17966:Array<ASAny> = ["waiting", "ok", "bad", "very_bad", "inconclusive", "searching"];
        static inline final _Str_10603= "${guide.bully.request.guide.results.outcome.";
        static inline final HELP_CHAT_REVIEW_DECISION_= "help_chat_review_decision_";

        var _habboHelp:HabboHelp;
        var _guideHelp:GuideHelpManager;
        var _window:IWindowContainer;
        var _reportWindow:IWindowContainer;
        var _sessionData:GuideSessionData;
        var _windowPosition:Point;
        var _onDuty:Bool = false;
        var _handleHelperRequests:Bool = false;
        var _handleGuardianRequests:Bool = false;
        var _handleGuideRequests:Bool = false;
        var _resubmitDescription:Bool = false;
        var _chatMsg:IWidgetWindow;
        var _chatMsgNotification:IWindowContainer;
        var _chatMsgReminder:IWindowContainer;
        var _disposed:Bool = false;
        var _typingTimer:Timer;
        var _lastMessageTypedLength:Int = 0;
        var _lastTypingInfo:Bool = false;
        var _waitingAnimationTimer:Timer;
        var _waitingAnimationData:Vector<AnimationData>;
        var _idleCheckTimer:Timer;
        var _idleCheckLastActivity:Int = 0;

        public function new(k:GuideHelpManager)
        {
            this._windowPosition = new Point(120, 80);
            this._habboHelp = k.habboHelp;
            this._guideHelp = k;
            this._sessionData = new GuideSessionData();
            this._chatMsg = cast(this._habboHelp.getXmlWindow("chat_msg"), IWidgetWindow);
            this._chatMsgNotification = cast(this._habboHelp.getXmlWindow("chat_msg_notification"), IWindowContainer);
            this._chatMsgReminder = cast(this._habboHelp.getXmlWindow("chat_msg_reminder"), IWindowContainer);
            this._handleHelperRequests = this._habboHelp.getBoolean("guidetool.handle.help_requests");
            this._handleGuardianRequests = this._habboHelp.getBoolean("guidetool.handle.chat_reviews");
            this._handleGuideRequests = this._habboHelp.getBoolean("guidetool.handle.tour_requests");
            this._habboHelp.context.displayObjectContainer.stage.addEventListener(MouseEvent.MOUSE_MOVE, (this._Str_3983 : ASAny));
            this._waitingAnimationData = new Vector<AnimationData>();
            this._waitingAnimationTimer = new Timer(_Str_16534);
            this._waitingAnimationTimer.addEventListener(TimerEvent.TIMER, (this._Str_22173 : ASAny));
            this._waitingAnimationTimer.start();
            this._idleCheckLastActivity = flash.Lib.getTimer();
            this._idleCheckTimer = new Timer(5000);
            this._idleCheckTimer.addEventListener(TimerEvent.TIMER, (this._Str_19672 : ASAny));
            this._idleCheckTimer.start();
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new GuideSessionAttachedMessageEvent(this.onGuideSessionAttached));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new GuideSessionDetachedMessageEvent(this.onGuideSessionDetached));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new GuideSessionStartedMessageEvent(this.onGuideSessionStarted));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new GuideSessionEndedMessageEvent(this.onGuideSessionEnded));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new GuideSessionErrorMessageEvent(this.onGuideSessionError));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new GuideSessionMessageMessageEvent(this.onGuideSessionMessage));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new GuideSessionRequesterRoomMessageEvent(this.onGuideSessionRequesterRoom));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new GuideSessionInvitedToGuideRoomMessageEvent(this.onGuideSessionInvitedToGuideRoom));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new GuideSessionPartnerIsTypingMessageEvent(this.onGuideSessionPartnerIsTyping));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new PerkAllowancesEvent(this.onPerkAllowances));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new GuideOnDutyStatusMessageEvent(this.onGuideOnDutyStatus));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new ChatReviewSessionOfferedToGuideMessageEvent(this.onChatReviewSessionOfferedToGuide));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new ChatReviewSessionStartedMessageEvent(this.onChatReviewSessionStarted));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new ChatReviewSessionVotingStatusMessageEvent(this.onChatReviewSessionVotingStatus));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new ChatReviewSessionResultsMessageEvent(this.onChatReviewSessionResults));
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new ChatReviewSessionDetachedMessageEvent(this.onChatReviewSessionDetached));
        }

        static function _Str_13055(k:Int):Int
        {
            var _local_2= ChatReviewSessionVotingStatusMessageParser._Str_14199;
            switch (k)
            {
                case _Str_10084:
                    _local_2 = ChatReviewSessionVotingStatusMessageParser._Str_18915;
                    
                case _Str_9791:
                    _local_2 = ChatReviewSessionVotingStatusMessageParser._Str_16095;
                    
                case _Str_10906:
                    _local_2 = ChatReviewSessionVotingStatusMessageParser._Str_16785;
                    
                case _Str_17188:
                    _local_2 = ChatReviewSessionVotingStatusMessageParser._Str_17026;
                    
            }
            return _local_2;
        }


        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            if (this._idleCheckTimer != null)
            {
                this._idleCheckTimer.stop();
                this._idleCheckTimer.removeEventListener(TimerEvent.TIMER, (this._Str_19672 : ASAny));
                this._idleCheckTimer = null;
            }
            if (this._waitingAnimationTimer != null)
            {
                this._waitingAnimationTimer.stop();
                this._waitingAnimationTimer.removeEventListener(TimerEvent.TIMER, (this._Str_22173 : ASAny));
                this._waitingAnimationTimer = null;
            }
            this._waitingAnimationData = null;
            if (this._chatMsg != null)
            {
                this._chatMsg.dispose();
                this._chatMsg = null;
            }
            if (this._chatMsgNotification != null)
            {
                this._chatMsgNotification.dispose();
                this._chatMsgNotification = null;
            }
            this.closeWindow();
            this._sessionData = null;
            this._windowPosition = null;
            this._guideHelp = null;
            if ((((this._habboHelp != null) && (this._habboHelp.context != null)) && (this._habboHelp.context.displayObjectContainer != null)))
            {
                this._habboHelp.context.displayObjectContainer.stage.removeEventListener(MouseEvent.MOUSE_MOVE, (this._Str_3983 : ASAny));
            }
            this._habboHelp = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function createHelpRequest(k:UInt)
        {
            if (this._sessionData._Str_15842())
            {
                Logger.log(["Can't create a new help request while another help request is ongoing"]);
                return;
            }
            if (((k == (_Str_2849._Str_4268 : UInt)) || (k == (_Str_2849._Str_4749 : UInt))))
            {
                this._sessionData._Str_17222 = GuideSessionData._Str_11013;
                this._sessionData._Str_3201 = GuideSessionStateEnum.USER_CREATE;
                this._sessionData.requestType = k;
                this._habboHelp.sendMessage(new GuideSessionCreateMessageComposer(ASCompat.toInt(k), this._habboHelp.localization.getLocalization("guide.help.request.tour.description")));
            }
            else
            {
                this._Str_22204(k);
            }
        }

        public function showGuideTool()
        {
            this._habboHelp.sendMessage(new GuideSessionOnDutyUpdateMessageComposer(this._onDuty, this._handleGuideRequests, this._handleHelperRequests, this._handleGuardianRequests));
        }

        function onGuideOnDutyStatus(k:GuideOnDutyStatusMessageEvent)
        {
            var _local_2= k.getParser();
            this._onDuty = _local_2.onDuty;
            this._habboHelp.localization.registerParameter("guide.help.guide.tool.guidesonduty", "amount", Std.string(_local_2._Str_24740));
            this._habboHelp.localization.registerParameter("guide.help.guide.tool.helpersonduty", "amount", Std.string(_local_2._Str_25148));
            this._habboHelp.localization.registerParameter("guide.help.guide.tool.guardiansonduty", "amount", Std.string(_local_2._Str_24092));
            this.setStateGuideTool();
        }

        function onGuideSessionAttached(k:IMessageEvent)
        {
            Logger.log(["onGuideSessionAttached"]);
            if ((this._disposed || (!(this._sessionData != null))))
            {
                Logger.log(["_diposed or no _sessionData"]);
                return;
            }
            var _local_2= Std.downcast(k.parser , GuideSessionAttachedMessageParser);
            if (_local_2._Str_23343)
            {
                if (this._sessionData._Str_5908())
                {
                    this._Str_17548();
                    return;
                }
                this._Str_22481(_local_2._Str_20566, _local_2._Str_19914, _local_2._Str_19737);
            }
            else
            {
                if (!this._sessionData._Str_5935())
                {
                    this._Str_17548();
                    return;
                }
                this._window8(_local_2._Str_20566, _local_2._Str_19914, _local_2._Str_19737);
            }
        }

        function onGuideSessionDetached(k:IMessageEvent)
        {
            var _local_2 = 0;
            var _local_3:String = null;
            Logger.log(["onGuideSessionDetached"]);
            if (this._disposed)
            {
                return;
            }
            if (this._resubmitDescription)
            {
                _local_2 = ASCompat.toInt(this._sessionData.requestType);
                _local_3 = this._sessionData._Str_8937;
                this._Str_20660();
                this._Str_22204(_local_2, _local_3);
            }
            else
            {
                if ((this._sessionData._Str_5935() && (this._sessionData._Str_3201 == GuideSessionStateEnum.USER_FEEDBACK)))
                {
                    this._Str_22593();
                }
                else
                {
                    this._Str_4260(true);
                }
            }
        }

        function onGuideSessionStarted(k:IMessageEvent)
        {
            Logger.log(["onGuideSessionStarted"]);
            if (this._disposed)
            {
                return;
            }
            var _local_2= Std.downcast(k.parser , GuideSessionStartedMessageParser);
            this._sessionData.userId = _local_2.requesterUserId;
            this._sessionData.userName = _local_2.requesterName;
            this._sessionData._Str_7586 = _local_2.requesterFigure;
            this._sessionData._Str_5587 = _local_2.guideUserId;
            this._sessionData.guideName = _local_2.guideName;
            this._sessionData.guideFigure = _local_2.guideFigure;
            this._lastTypingInfo = false;
            if (this._sessionData._Str_5908())
            {
                this._Str_24192();
            }
            else
            {
                this._Str_22431();
            }
        }

        function onGuideSessionEnded(k:IMessageEvent)
        {
            Logger.log(["onGuideSessionEnded"]);
            if (this._disposed)
            {
                return;
            }
            var _local_2= Std.downcast(k.parser , GuideSessionEndedMessageParser);
            if (this._sessionData._Str_5908())
            {
                this._Str_23339(_local_2.endReason);
            }
            else
            {
                if (_local_2.endReason == GuideSessionData._Str_14462)
                {
                    this._window4();
                }
                else
                {
                    this._Str_23699();
                }
            }
        }

        function onGuideSessionError(k:GuideSessionErrorMessageEvent)
        {
            Logger.log(["onGuideSessionError"]);
            if (this._disposed)
            {
                return;
            }
            var _local_2= k.getParser();
            switch (_local_2.errorCode)
            {
                case GuideSessionErrorMessageParser.ERROR_GUIDES_REJECT:
                    this._Str_22553();
                    return;
                case GuideSessionErrorMessageParser.ERROR_NOT_ENOUGH_GUIDES
                   | GuideSessionErrorMessageParser.ERROR_NOT_ENOUGH_VOTES:
                    this._Str_24880("guide.bully.request.error.not_enough_guardians");
                    return;
                default:
                    this._Str_17548();
            }
        }

        function onGuideSessionMessage(k:IMessageEvent)
        {
            var _local_4:String = null;
            var _local_5:String = null;
            Logger.log(["onGuideSessionMessage"]);
            if (((this._disposed || (!this._sessionData._Str_14646())) || (this._window == null)))
            {
                return;
            }
            var _local_2= Std.downcast(k.parser , GuideSessionMessageMessageParser);
            var _local_3= _local_2.senderId;
            if ((_local_3 : UInt) == this._sessionData._Str_5587)
            {
                _local_4 = this._sessionData.guideName;
                _local_5 = this._sessionData.guideFigure;
            }
            else
            {
                _local_4 = this._sessionData.userName;
                _local_5 = this._sessionData._Str_7586;
            }
            var _local_6= true;
            if ((this._sessionData._Str_5908() && (this._sessionData._Str_5587 == (_local_3 : UInt))))
            {
                _local_6 = false;
            }
            else
            {
                if (((!this._sessionData._Str_5908()) && (this._sessionData.userId == (_local_3 : UInt))))
                {
                    _local_6 = false;
                }
            }
            this.addChatMessage(_local_3, _local_4, _local_5, _local_2._Str_24208, _local_6);
        }

        function onGuideSessionRequesterRoom(k:IMessageEvent)
        {
            Logger.log(["onGuideSessionRequesterRoom"]);
            if ((this._disposed || (!this._sessionData._Str_14646())))
            {
                return;
            }
            var _local_2= Std.downcast(k.parser , GuideSessionRequesterRoomMessageParser);
            if (_local_2.getRequesterRoomId() > 0)
            {
                this._habboHelp.roomSessionManager.gotoRoom(_local_2.getRequesterRoomId());
            }
            else
            {
                this.addChatMessage(ASCompat.toInt(this._sessionData._Str_5587), this._sessionData.guideName, this._sessionData.guideFigure, this._habboHelp.localization.getLocalization("guide.help.request.guide.ongoing.user.not.in.room.error", ""), false, _Str_7012);
            }
        }

        function onGuideSessionInvitedToGuideRoom(k:IMessageEvent)
        {
            Logger.log(["onGuideSessionInvitedToGuideRoom"]);
            if (((this._disposed || (this._window == null)) || (!this._sessionData._Str_14646())))
            {
                return;
            }
            var _local_2= Std.downcast(k.parser , GuideSessionInvitedToGuideRoomMessageParser);
            if (this._sessionData._Str_5908())
            {
                if (_local_2.getRoomId() > 0)
                {
                    this._Str_14185(_Str_12638, this._habboHelp.localization.getLocalizationWithParams("guide.help.request.guide.ongoing.error.invite.success", "", ["name", this._sessionData.userName]));
                }
                else
                {
                    this._Str_14185(_Str_12638, this._habboHelp.localization.getLocalization("guide.help.request.guide.ongoing.error.invite.failed", ""));
                }
            }
            else
            {
                if (_local_2.getRoomId() > 0)
                {
                    this.addChatMessage(ASCompat.toInt(this._sessionData._Str_5587), this._sessionData.guideName, this._sessionData.guideFigure, this._habboHelp.localization.getLocalizationWithParams("guide.help.request.user.ongoing.visit.guide.request.message", "", ["name", this._sessionData.guideName, "roomname", _local_2.getRoomName()]), true, _Str_13205, _local_2.getRoomId());
                }
            }
        }

        function onGuideSessionPartnerIsTyping(k:IMessageEvent)
        {
            Logger.log(["onGuideSessionPartnerIsTyping"]);
            var _local_2= cast(k, GuideSessionPartnerIsTypingMessageEvent).getParser();
            this._Str_19579(_local_2.isTyping);
        }

        function onPerkAllowances(k:PerkAllowancesEvent)
        {
            var _local_2:PerkAllowancesMessageParser = null;
            if (this._sessionData._Str_3201 == GuideSessionStateEnum.GUIDE_TOOL)
            {
                _local_2 = k.getParser();
                if (!_local_2.isPerkAllowed(PerkEnum.USE_GUIDE_TOOL))
                {
                    if (this._onDuty)
                    {
                        this._Str_10865(false);
                        this._habboHelp.sendMessage(new GuideSessionOnDutyUpdateMessageComposer(false, false, false, false));
                    }
                    this._Str_4260(false);
                }
            }
        }

        function onChatReviewSessionOfferedToGuide(k:ChatReviewSessionOfferedToGuideMessageEvent)
        {
            this._Str_22573(k.getParser()._Str_23730);
        }

        function onChatReviewSessionStarted(k:ChatReviewSessionStartedMessageEvent)
        {
            var _local_2= k.getParser();
            this._Str_23588(_local_2._Str_23086, _local_2._Str_17106);
        }

        function onChatReviewSessionVotingStatus(k:ChatReviewSessionVotingStatusMessageEvent)
        {
            if (this._sessionData._Str_3201 != GuideSessionStateEnum.GUARDIAN_CHAT_REVIEW_WAIT_FOR_RESULTS)
            {
                return;
            }
            this._Str_19514(Std.downcast(this._window.findChildByName("results") , IItemListWindow), k.getParser().status);
        }

        function onChatReviewSessionResults(k:ChatReviewSessionResultsMessageEvent)
        {
            var _local_2= k.getParser();
            this._Str_22460(_local_2._Str_22263, _local_2._Str_25395, _local_2._Str_24620);
        }

        function onChatReviewSessionDetached(k:IMessageEvent)
        {
            this._Str_4260(true);
        }

        function setStateGuideTool()
        {
            var k:IItemListWindow = null;
            var _local_2:IWindowContainer = null;
            if (this._sessionData._Str_15842())
            {
                Logger.log(["Trying to set state to guide tool, but an active session exists"]);
                return;
            }
            this._sessionData._Str_3201 = GuideSessionStateEnum.GUIDE_TOOL;
            this.openWindow(this.onGuideToolEvent, true);
            this._Str_13929(this._onDuty);
            this._window.procedure = this.onGuideToolEvent;
            this._Str_18493("handle_guardian_tickets", this._handleGuardianRequests);
            this._Str_18493("handle_helper_tickets", this._handleHelperRequests);
            this._Str_18493("handle_guide_tickets", this._handleGuideRequests);
            if (!this._habboHelp.sessionDataManager.isPerkAllowed(PerkEnum.JUDGE_CHAT_REVIEWS))
            {
                k = cast(this._window.findChildByName("list"), IItemListWindow);
                _local_2 = Std.downcast(k.getListItemByName("handle_selection_container") , IWindowContainer);
                _local_2.findChildByName("handle_guardian_tickets").dispose();
                _local_2.findChildByName("selection_separator").y = (_local_2.findChildByName("selection_separator").y - 17);
                _local_2.height = (_local_2.height - 17);
            }
        }

        function onGuideToolEvent(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_4:String = null;
            if (((this.disposed || (this._window == null)) || (!(this._window.name == GuideSessionStateEnum.GUIDE_TOOL))))
            {
                return;
            }
            var _local_3 = 0;
            switch (_arg_2.name)
            {
                case "header_button_close":
                    if (k.type == WindowMouseEvent.CLICK)
                    {
                        this._Str_4260(false);
                    }
                    return;
                case "helper_group_link":
                    if (k.type == WindowMouseEvent.CLICK)
                    {
                        _local_3 = this._habboHelp.getInteger("guide.help.alpha.groupid", 0);
                        if (_local_3 > 0)
                        {
                            this._habboHelp.sendMessage(new GetHabboGroupDetailsMessageComposer(_local_3, true));
                            this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_groupProfile"));
                        }
                    }
                    return;
                case "guide_forum_link":
                    if (k.type == WindowMouseEvent.CLICK)
                    {
                        _local_3 = this._habboHelp.getInteger("guide.help.alpha.groupid", 0);
                        if (_local_3 > 0)
                        {
                            _local_4 = this._habboHelp.getProperty("group.homepage.url");
                            _local_4 = ASCompat.stringReplace(_local_4, "%groupid%", _local_3);
                            HabboWebTools.openWebPage(_local_4, "habboMain");
                            this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_groupForum"));
                        }
                    }
                    return;
                case "guide_tool_duty":
                    switch (k.type)
                    {
                        case WindowEvent.WINDOW_EVENT_SELECTED:
                            this._Str_13929(true);
                            this._handleHelperRequests = Std.downcast(this._window.findChildByName("handle_helper_tickets") , ICheckBoxWindow).Selected;
                            this._handleGuardianRequests = ((!(this._window.findChildByName("handle_guardian_tickets") == null)) && Std.downcast(this._window.findChildByName("handle_guardian_tickets") , ICheckBoxWindow).Selected);
                            this._handleGuideRequests = Std.downcast(this._window.findChildByName("handle_guide_tickets") , ICheckBoxWindow).Selected;
                            if ((((!this._handleHelperRequests) && (!this._handleGuardianRequests)) && (!this._handleGuideRequests)))
                            {
                                this._habboHelp.windowManager.simpleAlert("${guide.help.guide.tool.noqueueselected.caption}", "${guide.help.guide.tool.noqueueselected.subtitle}", "${guide.help.guide.tool.noqueueselected.message}");
                                this._Str_13929(false);
                                return;
                            }
                            this._habboHelp.sendMessage(new GuideSessionOnDutyUpdateMessageComposer(true, this._handleGuideRequests, this._handleHelperRequests, this._handleGuardianRequests));
                            this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_onDuty"));
                            
                        case WindowEvent.WINDOW_EVENT_UNSELECTED:
                            this._Str_13929(false);
                            this._habboHelp.sendMessage(new GuideSessionOnDutyUpdateMessageComposer(false, false, false, false));
                            this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_offDuty"));
                            
                    }
                    return;
                case "guide_tool_talent":
                    if (k.type == WindowMouseEvent.CLICK)
                    {
                        if (this._habboHelp.getBoolean("talent.track.enabled"))
                        {
                            this._habboHelp.tracking.trackTalentTrackOpen(TalentEnum.HELPER, "guidetool");
                            this._habboHelp.sendMessage(new GetTalentTrackMessageComposer(TalentEnum.HELPER));
                            this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_talent"));
                        }
                    }
                    return;
            }
        }

        function _Str_22481(k:Int, _arg_2:String, _arg_3:Int)
        {
            var _local_5:IWindow = null;
            var _local_6:ITextWindow = null;
            var _local_7:IItemListWindow = null;
            var _local_8 = 0;
            var _local_9 = 0;
            if (((!this._onDuty) || this._sessionData._Str_15842()))
            {
                Logger.log(["Trying to set state to guide accept, but not on duty or active session exists"]);
                return;
            }
            this._sessionData._Str_3201 = GuideSessionStateEnum.GUIDE_ACCEPT;
            this._sessionData._Str_17222 = GuideSessionData._Str_15093;
            this._sessionData._Str_8937 = _arg_2;
            this._sessionData.requestType = k;
            this.openWindow(this.onGuideAcceptEvent, false);
            this._habboHelp.soundManager.playSound(HabboSoundTypesEnum.GUIDE_REQUEST);
            if (((k == _Str_2849._Str_4749) || (k == _Str_2849._Str_4268)))
            {
                this._window.findChildByName("frank_greeting").visible = true;
                this._window.findChildByName("request_title").caption = "${guide.help.request.guide.accept.tour_request.title}";
                this._window.findChildByName("request_type").dispose();
                _local_5 = this._window.findChildByName("request_description_wrapper");
                _local_6 = Std.downcast(this._window.findChildByName("request_description") , ITextWindow);
                _local_7 = Std.downcast(this._window.findChildByName("itemlist") , IItemListWindow);
                _local_7.addListItemAt(_local_6, _local_7.getListItemIndex(_local_5));
                _local_7.removeListItem(_local_5);
                _local_6.x = this._window.findChildByName("request_title").x;
                _local_6.margins.top = 10;
                _local_6.caption = _arg_2;
                _local_8 = _local_7.height;
                _local_9 = this._window.findChildByName("skip_link").bottom;
                _local_7.height = _local_9;
                this._window.findChildByName("border").height = (this._window.findChildByName("border").height + (_local_9 - _local_8));
                this._window.height = (this._window.height + ((_local_9 - _local_8) + 40));
            }
            else
            {
                this._window.findChildByName("request_type").caption = this._Str_20710(k);
                this._window.findChildByName("request_description").caption = _arg_2;
            }
            var _local_4= cast(cast(this._window.findChildByName("countdown"), IWidgetWindow).widget, ICountdownWidget);
            _local_4.seconds = _arg_3;
            _local_4.running = true;
        }

        function onGuideAcceptEvent(k:WindowEvent, _arg_2:IWindow)
        {
            if ((((this.disposed || (this._window == null)) || (!(this._window.name == GuideSessionStateEnum.GUIDE_ACCEPT))) || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "accept_button":
                    this._habboHelp.sendMessage(new GuideSessionGuideDecidesMessageComposer(true));
                    this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_clickAccept"));
                    this.closeWindow();
                    return;
                case "skip_link":
                    this._habboHelp.sendMessage(new GuideSessionGuideDecidesMessageComposer(false));
                    this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_clickSkip"));
                    this.closeWindow();
                    return;
            }
        }

        function _Str_24192()
        {
            var title:String = null;
            var summary:String = null;
            if (((!this._onDuty) || (!this._sessionData._Str_5908())))
            {
                Logger.log(["Trying to set state to guide ongoing, but not on duty or no active guide session"]);
                return;
            }
            this._sessionData._Str_3201 = GuideSessionStateEnum.GUIDE_ONGOING;
            this.openWindow(this._Str_23050, false);
            this.addChatMessage(ASCompat.toInt(this._sessionData.userId), this._sessionData.userName, this._sessionData._Str_7586, this._sessionData._Str_8937, true, _Str_7012);
            this._window.caption = this._habboHelp.localization.getLocalizationWithParams("guide.help.request.guide.ongoing.title", "", ["name", this._sessionData.userName]);
            var inputWidget= cast(cast(this._window.findChildByName("input_widget"), IWidgetWindow).widget, IIlluminaInputWidget);
            inputWidget.submitHandler = this;
            inputWidget.emptyMessage = this._habboHelp.localization.getLocalizationWithParams("guide.help.request.guide.ongoing.input.empty", "", ["name", this._sessionData.userName]);
            inputWidget.maxChars = this._habboHelp.getInteger("guide.help.request.max.chat.message.length", 150);
            if (((this._sessionData.requestType == (_Str_2849._Str_4749 : UInt)) || (this._sessionData.requestType == (_Str_2849._Str_4268 : UInt))))
            {
                title = "${guide.help.request.join.room.title}";
                summary = this._habboHelp.localization.getLocalizationWithParams("guide.help.request.join.room.summary", "", ["name", this._sessionData.userName]);
                this._habboHelp.windowManager.confirm(title, summary, 0, function (k:com.sulake.habbo.window.utils.IConfirmDialog, _arg_2:WindowEvent)
                {
                    k.dispose();
                    if (_arg_2.type == WindowEvent.WINDOW_EVENT_OK)
                    {
                        _habboHelp.sendMessage(new GuideSessionGetRequesterRoomMessageComposer());
                    }
                });
            }
        }

        function _Str_23050(k:WindowEvent, _arg_2:IWindow)
        {
            if ((((this.disposed || (this._window == null)) || (!(this._window.name == GuideSessionStateEnum.GUIDE_ONGOING))) || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "visit_button":
                    this._habboHelp.sendMessage(new GuideSessionGetRequesterRoomMessageComposer());
                    this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_clickVisit"));
                    return;
                case "invite_button":
                    this._habboHelp.sendMessage(new GuideSessionInviteRequesterMessageComposer());
                    this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_clickInvite"));
                    return;
                case "report_link":
                    this._Str_10116();
                    this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_clickReport"));
                    return;
                case "close_link":
                    this._habboHelp.sendMessage(new GuideSessionResolvedMessageComposer());
                    this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_clickClose"));
                    this.closeWindow();
                    return;
            }
        }

        function _Str_23339(k:Int)
        {
            if (((!this._onDuty) || (!this._sessionData._Str_5908())))
            {
                Logger.log(["Trying to set state to guide ongoing, but not on duty or no active guide session"]);
                return;
            }
            this._sessionData._Str_3201 = GuideSessionStateEnum.GUIDE_CLOSED;
            this.openWindow(this.onGuideClosedEvent, true);
            if (((k == GuideSessionData._Str_14462) || (k == GuideSessionData._Str_19034)))
            {
                this._window.findChildByName("close_reason").caption = this._habboHelp.localization.getLocalizationWithParams("guide.help.request.guide.closed.reason.other", "", ["name", this._sessionData.userName]);
            }
            else
            {
                this._window.findChildByName("close_reason").caption = this._habboHelp.localization.getLocalization("guide.help.request.guide.closed.reason.you", "");
            }
            this._window.findChildByName("report_link").caption = this._habboHelp.localization.getLocalizationWithParams("guide.help.request.guide.closed.report.link", "", ["name", this._sessionData.userName]);
            cast(cast(this._window.findChildByName("requester_avatar"), IWidgetWindow).widget, IAvatarImageWidget).figure = this._sessionData._Str_7586;
        }

        function onGuideClosedEvent(k:WindowEvent, _arg_2:IWindow)
        {
            if ((((this.disposed || (this._window == null)) || (!(this._window.name == GuideSessionStateEnum.GUIDE_CLOSED))) || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "close_button"
                   | "header_button_close":
                    this._habboHelp.sendMessage(new GuideSessionFeedbackMessageComposer(true));
                    this.closeWindow();
                    return;
                case "report_link":
                    this._Str_10116();
                    this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_clickReport"));
                    return;
            }
        }

        function _Str_22204(k:UInt, _arg_2:String=null)
        {
            if (this._sessionData._Str_15842())
            {
                Logger.log(["Trying to set state to user create, but active session exists"]);
                return;
            }
            this._sessionData._Str_17222 = GuideSessionData._Str_11013;
            this._sessionData._Str_3201 = GuideSessionStateEnum.USER_CREATE;
            this._sessionData.requestType = k;
            this.openWindow(this.onUserCreateEvent, true);
            var _local_3= cast(cast(this._window.findChildByName("input_widget"), IWidgetWindow).widget, IIlluminaInputWidget);
            _local_3.maxChars = this._habboHelp.getInteger("guide.help.request.max.description.length", 0xFF);
            if (ASCompat.stringAsBool(_arg_2))
            {
                _local_3.message = _arg_2;
            }
        }

        function onUserCreateEvent(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:String = null;
            if ((((this.disposed || (this._window == null)) || (!(this._window.name == GuideSessionStateEnum.USER_CREATE))) || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "create_button":
                    _local_3 = StringUtil.trim(cast(cast(this._window.findChildByName("input_widget"), IWidgetWindow).widget, IIlluminaInputWidget).message);
                    if (_local_3.length < this._habboHelp.getInteger("guide.help.request.min.description.length", 15))
                    {
                        this._window.findChildByName("create_error").visible = true;
                        cast(this._window.findChildByName("list"), IItemListWindow).arrangeListItems();
                    }
                    else
                    {
                        this._habboHelp.sendMessage(new GuideSessionCreateMessageComposer(ASCompat.toInt(this._sessionData.requestType), _local_3));
                        this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_clickCreate"));
                        this.closeWindow();
                    }
                    return;
                case "header_button_close"
                   | "cancel_link":
                    this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_clickCancel"));
                    this._Str_4260(true);
                    return;
            }
        }

        function _window8(k:Int, _arg_2:String, _arg_3:Int)
        {
            if (!this._sessionData._Str_5935())
            {
                Logger.log(["Trying to set state to user pending request, but no active user session"]);
                return;
            }
            this._sessionData._Str_3201 = GuideSessionStateEnum.USER_PENDING;
            this._sessionData.requestType = k;
            this._sessionData._Str_8937 = _arg_2;
            this.openWindow(this._Str_23008, false);
            this._window.findChildByName("request_type").caption = this._Str_20710(k);
            this._window.findChildByName("request_description").caption = _arg_2;
            this._window.findChildByName("waiting_time").caption = this._habboHelp.localization.getLocalizationWithParams("guide.help.request.user.pending.info.waiting", "", ["waitingtime", FriendlyTime.format(this._habboHelp.localization, _arg_3)]);
        }

        function _Str_23008(k:WindowEvent, _arg_2:IWindow)
        {
            if ((((this.disposed || (this._window == null)) || (!(this._window.name == GuideSessionStateEnum.USER_PENDING))) || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "cancel_button":
                    this._habboHelp.sendMessage(new GuideSessionRequesterCancelsMessageComposer());
                    this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_clickCancel"));
                    this.closeWindow();
                    return;
            }
        }

        function _Str_22431()
        {
            if (!this._sessionData._Str_5935())
            {
                Logger.log(["Trying to set state to user ongoing request, but no active user session"]);
                return;
            }
            this._sessionData._Str_3201 = GuideSessionStateEnum.USER_ONGOING;
            this.openWindow(this._Str_22821, false);
            this._Str_14185(_Str_14376, this._habboHelp.localization.getLocalization("guide.help.requester.disclaimer"));
            if (((this._sessionData.requestType == (_Str_2849._Str_4268 : UInt)) || (this._sessionData.requestType == (_Str_2849._Str_4749 : UInt))))
            {
                this._Str_14185(_Str_13767, this._habboHelp.localization.getLocalization("guide.help.request.tour.reminder"));
            }
            else
            {
                this.addChatMessage(ASCompat.toInt(this._sessionData.userId), this._sessionData.userName, this._sessionData._Str_7586, this._sessionData._Str_8937, false, _Str_7012);
            }
            this._window.caption = this._habboHelp.localization.getLocalizationWithParams("guide.help.request.user.ongoing.title", "", ["name", this._sessionData.guideName]);
            this._window.findChildByName("guide_name_link").caption = this._sessionData.guideName;
            var k= cast(cast(this._window.findChildByName("input_widget"), IWidgetWindow).widget, IIlluminaInputWidget);
            k.submitHandler = this;
            k.emptyMessage = this._habboHelp.localization.getLocalizationWithParams("guide.help.request.user.ongoing.input.help", "", ["name", this._sessionData.guideName]);
            k.maxChars = this._habboHelp.getInteger("guide.help.request.max.chat.message.length", 150);
        }

        function _Str_22821(k:WindowEvent, _arg_2:IWindow)
        {
            if ((((this.disposed || (this._window == null)) || (!(this._window.name == GuideSessionStateEnum.USER_ONGOING))) || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "guide_name_link":
                    this._habboHelp.sendMessage(new GetExtendedProfileMessageComposer(ASCompat.toInt(this._sessionData._Str_5587)));
                    this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_clickProfile"));
                    return;
                case "report_guide_link":
                    this._Str_10116();
                    this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_clickReport"));
                    return;
                case "close_link":
                    this._habboHelp.sendMessage(new GuideSessionResolvedMessageComposer());
                    this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_clickClose"));
                    this.closeWindow();
                    return;
            }
        }

        function _window4()
        {
            if (!this._sessionData._Str_5935())
            {
                Logger.log(["Trying to set state to user guide disconnected, but no active user session"]);
                return;
            }
            this._sessionData._Str_3201 = GuideSessionStateEnum.USER_GUIDE_DISCONNECTED;
            this.openWindow(this.onUserGuideDisconnected, true);
            this._window.findChildByName("guide_name_link").caption = this._sessionData.guideName;
        }

        function onUserGuideDisconnected(k:WindowEvent, _arg_2:IWindow)
        {
            if ((((this.disposed || (this._window == null)) || (!(this._window.name == GuideSessionStateEnum.USER_GUIDE_DISCONNECTED))) || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "header_button_close":
                    this._habboHelp.sendMessage(new GuideSessionFeedbackMessageComposer(false));
                    this.closeWindow();
                    return;
                case "guide_name_link":
                    this._habboHelp.sendMessage(new GetExtendedProfileMessageComposer(ASCompat.toInt(this._sessionData._Str_5587)));
                    this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_clickProfile"));
                    return;
                case "report_guide_link":
                    this._Str_10116();
                    this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_clickReport"));
                    return;
                case "resubmit_button":
                    this._resubmitDescription = true;
                    this._habboHelp.sendMessage(new GuideSessionFeedbackMessageComposer(false));
                    this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_clickResubmit"));
                    this.closeWindow();
                    return;
            }
        }

        function _Str_23699()
        {
            if (!this._sessionData._Str_5935())
            {
                Logger.log(["Trying to set state to user feedback, but no active user session"]);
                return;
            }
            this._sessionData._Str_3201 = GuideSessionStateEnum.USER_FEEDBACK;
            this.openWindow(this.onUserFeedbackEvent, false);
            this._window.findChildByName("guide_name_link").caption = this._sessionData.guideName;
        }

        function onUserFeedbackEvent(k:WindowEvent, _arg_2:IWindow)
        {
            if ((((this.disposed || (this._window == null)) || (!(this._window.name == GuideSessionStateEnum.USER_FEEDBACK))) || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "guide_name_link":
                    this._habboHelp.sendMessage(new GetExtendedProfileMessageComposer(ASCompat.toInt(this._sessionData._Str_5587)));
                    this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_clickProfile"));
                    return;
                case "report_guide_link":
                    this._Str_10116();
                    this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_clickReport"));
                    return;
                case "positive_button":
                    this._habboHelp.sendMessage(new GuideSessionFeedbackMessageComposer(true));
                    this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_clickPositiveFeedback"));
                    this.closeWindow();
                    return;
                case "negative_button":
                    this._habboHelp.sendMessage(new GuideSessionFeedbackMessageComposer(false));
                    this._habboHelp.trackGoogle("guideHelp", (this._window.name + "_clickNegativeFeedback"));
                    this.closeWindow();
                    return;
            }
        }

        function _Str_22593()
        {
            if (!this._sessionData._Str_5935())
            {
                Logger.log(["Trying to set state to user thanks, but no active user session"]);
                return;
            }
            this._sessionData._Str_3201 = GuideSessionStateEnum.USER_THANKS;
            this.openWindow(this._Str_24558, true);
        }

        function _Str_24558(k:WindowEvent, _arg_2:IWindow)
        {
            if ((((this.disposed || (this._window == null)) || (!(this._window.name == GuideSessionStateEnum.USER_THANKS))) || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "header_button_close"
                   | "close_button":
                    this._Str_4260(false);
                    return;
            }
        }

        function _Str_22573(k:Int)
        {
            this._sessionData._Str_3201 = GuideSessionStateEnum.GUARDIAN_CHAT_REVIEW_ACCEPT;
            this.openWindow(this.onGuardianChatReviewAcceptEvent, false);
            this._habboHelp.soundManager.playSound(HabboSoundTypesEnum.GUIDE_REQUEST);
            var _local_2= Std.downcast(cast(this._window.findChildByName("countdown"), IWidgetWindow).widget , ICountdownWidget);
            _local_2.seconds = k;
            _local_2.running = true;
        }

        function onGuardianChatReviewAcceptEvent(k:WindowEvent, _arg_2:IWindow)
        {
            if (((this.disposed || (this._window == null)) || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "skip_link":
                    this._habboHelp.sendMessage(new ChatReviewGuideDecidesOnOfferMessageComposer(false));
                    this._Str_4260(true);
                    return;
                case "accept_button":
                    this._habboHelp.sendMessage(new ChatReviewGuideDecidesOnOfferMessageComposer(true));
                    this._Str_24340();
                    return;
            }
        }

        function _Str_24340()
        {
            this._sessionData._Str_3201 = GuideSessionStateEnum.GUARDIAN_CHAT_REVIEW_WAIT_FOR_VOTERS;
            this.openWindow(this._Str_25421, false);
            this._Str_20955(Std.downcast(this._window.findChildByName("waiting_animation") , IStaticBitmapWrapperWindow), "help_chat_review_progress_big", 4);
        }

        function _Str_25421(k:WindowEvent, _arg_2:IWindow)
        {
            if (((this.disposed || (this._window == null)) || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "close_link":
                    this._habboHelp.sendMessage(new ChatReviewGuideDetachedMessageComposer());
                    this._Str_4260(true);
                    return;
            }
        }

        function _Str_23588(k:Int, _arg_2:String)
        {
            var _local_5:Date = null;
            var _local_13:String = null;
            var _local_14:Array<ASAny> = null;
            var _local_15 = 0;
            var _local_16:String = null;
            var _local_17 = false;
            var _local_18:String = null;
            this._sessionData._Str_3201 = GuideSessionStateEnum.GUARDIAN_CHAT_REVIEW_VOTE;
            this.openWindow(this._Str_23629, false);
            var _local_3= Std.downcast(cast(this._window.findChildByName("countdown"), IWidgetWindow).widget , ICountdownWidget);
            _local_3.seconds = k;
            _local_3.running = true;
            var _local_4:Array<ASAny> = (cast ASCompat.stringMatch(_arg_2.substr(0, _arg_2.indexOf(";")), new compat.RegExp("\\d+", "g")));
            if (_local_4.length > 5)
            {
                _local_5 = ASCompat.newDateWithMilliseconds(_local_4[0], (ASCompat.toInt(_local_4[1]) - 1), _local_4[2], _local_4[3], _local_4[4], _local_4[5]);
            }
            else
            {
                _local_5 = Date.now();
            }
            var _local_6= ((Date.now().getTime() - _local_5.getTime()) / 1000);
            this._window.findChildByName("incident_time").caption = (("(" + FriendlyTime.format(this._habboHelp.localization, _local_6, ".ago")) + ")");
            var _local_7= Std.downcast(this._window.findChildByName("chatlog") , IItemListWindow);
            var _local_8= this._window.findChildByName("reported_user_template");
            var _local_9= this._window.findChildByName("other_user_template");
            var _local_10= this._window.findChildByName("separator_template");
            _local_7.removeListItems();
            var _local_11= -1;
            var _local_12:IWindowContainer = null;
            final _iter_ = _arg_2.split("\r"); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_13  = _tmp_;
                if (_local_13 == "")
                {
                }
                else
                {
                    _local_14 = (cast ASCompat.stringSplit(_local_13, ";", 3));
                    _local_15 = 1;
                    if (_local_14.length < 3)
                    {
                    }
                    else
                    {
                        _local_15 = ASCompat.toInt(_local_14[1]);
                        _local_16 = ASCompat.stringReplace(ASCompat.stringReplace(ASCompat.toString(_local_14[2]), "<", "&lt;"), ">", "&gt;");
                        if (((_local_15 == _local_11) && (!(_local_12 == null))))
                        {
                            _local_12.findChildByName("message").caption = (_local_12.findChildByName("message").caption + ("\n" + _local_16));
                        }
                        else
                        {
                            _local_17 = (_local_15 == 0);
                            _local_12 = Std.downcast((_local_17 ? _local_8.clone() : _local_9.clone()) , IWindowContainer);
                            _local_18 = (_local_17 ? this._habboHelp.localization.getLocalization("guide.bully.request.guide.vote.perpetrator", "") : this._habboHelp.localization.getLocalizationWithParams("guide.bully.request.guide.vote.anonymous", "%ID%", ["id", Std.string(_local_15)]));
                            _local_12.findChildByName("message").caption = ((("<b>" + _local_18) + ":</b> ") + _local_16);
                            _local_7.addListItem(_local_12);
                            _local_11 = _local_15;
                        }
                    }
                }
            }
        }

        function _Str_23629(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:String = null;
            var _local_4:IRegionWindow = null;
            var _local_5:String = null;
            var _local_6:IStaticBitmapWrapperWindow = null;
            if ((this.disposed || (this._window == null)))
            {
                return;
            }
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "close_link":
                        this._habboHelp.sendMessage(new ChatReviewGuideDetachedMessageComposer());
                        this._Str_4260(true);
                        
                    case "vote_ok":
                        this._habboHelp.sendMessage(new ChatReviewGuideVoteMessageComposer(_Str_10084));
                        this._Str_18645(_Str_10084);
                        
                    case "vote_bad":
                        this._habboHelp.sendMessage(new ChatReviewGuideVoteMessageComposer(_Str_9791));
                        this._Str_18645(_Str_9791);
                        
                    case "vote_very_bad":
                        this._habboHelp.sendMessage(new ChatReviewGuideVoteMessageComposer(_Str_10906));
                        this._Str_18645(_Str_10906);
                        
                }
            }
            else
            {
                if (((_arg_2.type == WindowType.WINDOW_TYPE_REGION) && (_arg_2.name.substr(0, 5) == "vote_")))
                {
                    _local_3 = _arg_2.name.substr(5);
                    _local_4 = Std.downcast(_arg_2 , IRegionWindow);
                    _local_5 = ("help_chat_review_vote_" + _local_3);
                    _local_6 = Std.downcast(_local_4.getChildAt(0) , IStaticBitmapWrapperWindow);
                    switch (k.type)
                    {
                        case WindowMouseEvent.OVER:
                            _local_6.id = (_local_6.id | 0x01);
                            
                        case WindowMouseEvent.OUT:
                            _local_6.id = (_local_6.id & (~0x01));
                            
                        case WindowMouseEvent.DOWN:
                            _local_6.id = (_local_6.id | 0x02);
                            
                        case WindowMouseEvent.UP
                           | WindowMouseEvent.UP_OUTSIDE:
                            _local_6.id = (_local_6.id & (~0x02));
                            
                    }
                    switch (_local_6.id)
                    {
                        case 1:
                            _local_6.assetUri = (_local_5 + "_over");
                            return;
                        case 3:
                            _local_6.assetUri = (_local_5 + "_down");
                            return;
                        default:
                            _local_6.assetUri = _local_5;
                    }
                }
            }
        }

        function _Str_18645(k:Int)
        {
            this._sessionData._Str_3201 = GuideSessionStateEnum.GUARDIAN_CHAT_REVIEW_WAIT_FOR_RESULTS;
            this.openWindow(this._Str_25506, true);
            this._Str_20571(k);
        }

        function _Str_25506(k:WindowEvent, _arg_2:IWindow)
        {
            if (((this.disposed || (this._window == null)) || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "header_button_close"
                   | "close_button":
                    this._habboHelp.sendMessage(new ChatReviewGuideDetachedMessageComposer());
                    this._Str_4260(true);
                    return;
            }
        }

        function _Str_22460(k:Int, _arg_2:Int, _arg_3:Array<ASAny>)
        {
            this._sessionData._Str_3201 = GuideSessionStateEnum.GUARDIAN_CHAT_REVIEW_RESULTS;
            this.openWindow(this._Str_22977, true);
            var _local_4= _Str_13055(k);
            this._window.findChildByName("result_text").caption = ((_Str_10603 + _Str_17966[_local_4]) + "}");
            cast(this._window.findChildByName("result_image"), IStaticBitmapWrapperWindow).assetUri = (HELP_CHAT_REVIEW_DECISION_ + _Str_6777[_local_4]);
            this._Str_20571(_arg_2);
            this._Str_19514(Std.downcast(this._window.findChildByName("results") , IItemListWindow), _arg_3);
        }

        function _Str_22977(k:WindowEvent, _arg_2:IWindow)
        {
            if (((this.disposed || (this._window == null)) || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "header_button_close"
                   | "close_button":
                    this._habboHelp.sendMessage(new ChatReviewGuideDetachedMessageComposer());
                    this._Str_4260(true);
                    return;
            }
        }

        function _Str_20571(k:Int)
        {
            var _local_2= _Str_13055(k);
            this._window.findChildByName("vote_text").caption = ((_Str_10603 + _Str_6777[_local_2]) + "}");
            cast(this._window.findChildByName("vote_image"), IStaticBitmapWrapperWindow).assetUri = (HELP_CHAT_REVIEW_DECISION_ + _Str_6777[_local_2]);
        }

        function _Str_19514(k:IItemListWindow, _arg_2:Array<ASAny>)
        {
            var _local_3:IWindowContainer = null;
            var _local_4 = 0;
            var _local_5:IWindowContainer = null;
            var _local_6 = 0;
            var _local_7:IStaticBitmapWrapperWindow = null;
            if (k.numListItems < (_arg_2.length + 1))
            {
                _local_5 = Std.downcast(k.getListItemAt(0) , IWindowContainer);
                _local_4 = 0;
                while (_local_4 < _arg_2.length)
                {
                    _local_3 = Std.downcast(_local_5.clone() , IWindowContainer);
                    k.addListItem(_local_3);
                    _local_4++;
                }
                _local_3.findChildByName("vote_separator").dispose();
            }
            _local_4 = 0;
            while (_local_4 < _arg_2.length)
            {
                _local_3 = Std.downcast(k.getListItemAt((_local_4 + 1)) , IWindowContainer);
                _local_6 = ASCompat.toInt(_arg_2[_local_4]);
                _local_7 = Std.downcast(_local_3.findChildByName("vote_image") , IStaticBitmapWrapperWindow);
                _local_3.findChildByName("vote_text").caption = ((_Str_10603 + _Str_6777[_local_6]) + "}");
                this._window6(_local_7);
                switch (_local_6)
                {
                    case ChatReviewSessionVotingStatusMessageParser._Str_14199
                       | ChatReviewSessionVotingStatusMessageParser._Str_17414:
                        this._Str_20955(_local_7, (HELP_CHAT_REVIEW_DECISION_ + _Str_6777[_local_6]), 2);
                        
                    default:
                        _local_7.assetUri = (HELP_CHAT_REVIEW_DECISION_ + _Str_6777[_local_6]);
                }
                _local_4++;
            }
        }

        function _Str_24880(k:String)
        {
            this._habboHelp.windowManager.simpleAlert((("${" + k) + ".title}"), (("${" + k) + ".heading}"), (("${" + k) + ".message}"));
            this._Str_4260(true);
        }

        function _Str_17548()
        {
            this._Str_10865(false);
            this._sessionData._Str_3201 = GuideSessionStateEnum.ERROR;
            this.openWindow(this._Str_22344, true);
        }

        function _Str_22344(k:WindowEvent, _arg_2:IWindow)
        {
            if ((((this.disposed || (this._window == null)) || (!(this._window.name == GuideSessionStateEnum.ERROR))) || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "header_button_close"
                   | "close_button":
                    this._Str_4260(true);
                    return;
            }
        }

        function _Str_22553()
        {
            this._Str_10865(false);
            this._sessionData._Str_3201 = GuideSessionStateEnum.REJECTED;
            this.openWindow(this._Str_22562, true);
            if (((this._sessionData.requestType == (_Str_2849._Str_4268 : UInt)) || (this._sessionData.requestType == (_Str_2849._Str_4749 : UInt))))
            {
                this._window.caption = "${guide.help.request.no_tour_guides.title}";
                this._window.findChildByName("heading").caption = "${guide.help.request.no_tour_guides.heading}";
                this._window.findChildByName("message").caption = "${guide.help.request.no_tour_guides.message}";
            }
        }

        function _Str_22562(k:WindowEvent, _arg_2:IWindow)
        {
            if ((((this.disposed || (this._window == null)) || (!(this._window.name == GuideSessionStateEnum.REJECTED))) || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "header_button_close"
                   | "close_button":
                    this._Str_4260(true);
                    return;
            }
        }

        function _Str_4260(k:Bool)
        {
            this._Str_20660();
            this.closeWindow();
            if ((this._onDuty && (!this._habboHelp.sessionDataManager.isPerkAllowed(PerkEnum.USE_GUIDE_TOOL))))
            {
                this._Str_10865(false);
            }
            if ((k && this._onDuty))
            {
                this.setStateGuideTool();
            }
        }

        function openWindow(k:ASFunction, _arg_2:Bool)
        {
            if (this._disposed)
            {
                return;
            }
            if (this._window != null)
            {
                this.closeWindow();
            }
            Logger.log([("Opening window " + this._sessionData._Str_3201)]);
            this._window = Std.downcast(this._guideHelp.habboHelp.getXmlWindow(this._sessionData._Str_3201) , IWindowContainer);
            this._window.position = this._windowPosition;
            this._window.procedure = k;
            this._window.findChildByName("header_button_close").visible = _arg_2;
        }

        function closeWindow()
        {
            if (this._window != null)
            {
                Logger.log([("Closing window: " + this._window.name)]);
                this._windowPosition.x = Math.max(0, this._window.position.x);
                this._windowPosition.y = Math.max(0, this._window.position.y);
                this._window.dispose();
                this._window = null;
            }
        }

        function _Str_10116()
        {
            this._habboHelp.queryForPendingCallsForHelp(HabboHelp.REPORT_TYPE_GUIDE);
        }

        public function openReportWindow()
        {
            if (((this._reportWindow != null) || (this._window == null)))
            {
                return;
            }
            var k= this._habboHelp.windowManager.getDesktop(0);
            this._reportWindow = cast(this._habboHelp.getXmlWindow("report_window"), IWindowContainer);
            this._reportWindow.procedure = this.onReportWindowEvent;
            this._reportWindow.x = Std.int(Math.max(0, Math.min((k.width - this._reportWindow.width), ((this._window.x + this._window.width) + 10))));
            this._reportWindow.y = Std.int(Math.max(0, this._window.y));
        }

        function _Str_19564()
        {
            if (this._reportWindow != null)
            {
                this._reportWindow.dispose();
                this._reportWindow = null;
            }
        }

        function onReportWindowEvent(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:String = null;
            if ((((this.disposed || (!(this._reportWindow != null))) || this._reportWindow.disposed) || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "header_button_close"
                   | "cancel_link":
                    this._habboHelp.trackGoogle("guideHelp", (this._reportWindow.name + "_clickClose"));
                    this._Str_19564();
                    return;
                case "urgent_help_link":
                    return;
                case "submit_button":
                    _local_3 = cast(cast(this._reportWindow.findChildByName("input_widget"), IWidgetWindow).widget, IIlluminaInputWidget).message;
                    if (_local_3.length == 0)
                    {
                        this._reportWindow.findChildByName("report_error").visible = true;
                        cast(this._reportWindow.findChildByName("list"), IItemListWindow).arrangeListItems();
                    }
                    else
                    {
                        this._habboHelp.sendMessage(new GuideSessionReportMessageComposer(_local_3));
                        this._habboHelp.trackGoogle("guideHelp", (this._reportWindow.name + "_clickReport"));
                        this._Str_19564();
                        this.closeWindow();
                    }
                    return;
            }
        }

        function _Str_20660()
        {
            this._sessionData = new GuideSessionData();
        }

        function _Str_13929(k:Bool)
        {
            var _local_2= cast(this._window.findChildByName("guide_tool_duty"), ICheckBoxWindow);
            this._Str_10865(k);
            _local_2.Selected = k;
            if (k)
            {
                _local_2.caption = this._habboHelp.localization.getLocalization("guide.help.guide.tool.duty.on", "");
            }
            else
            {
                _local_2.caption = this._habboHelp.localization.getLocalization("guide.help.guide.tool.duty.off", "");
            }
            var _local_3= this._window.findChildByName("disabled_screen");
            if (_local_3 != null)
            {
                _local_3.visible = k;
            }
        }

        function _Str_18493(k:String, _arg_2:Bool)
        {
            var _local_3= Std.downcast(this._window.findChildByName(k) , ICheckBoxWindow);
            if (_local_3 != null)
            {
                _local_3.Selected = _arg_2;
            }
        }

        function _Str_20710(k:Int):String
        {
            if (k == _Str_2849._Str_4749)
            {
                k = _Str_2849._Str_4268;
            }
            return this._habboHelp.localization.getLocalization(("guide.help.request.type." + Std.string(k)), "");
        }

        function addChatMessage(k:Int, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:Bool, _arg_6:Int=0, _arg_7:ASAny=null)
        {
            var _local_8:IWidgetWindow = null;
            var _local_9:IIlluminaChatBubbleWidget = null;
            var _local_10:IWindowContainer = null;
            _local_8 = this._Str_23250();
            if ((((!(_local_8 == null)) && (!(null == Std.downcast(_local_8.widget , IIlluminaChatBubbleWidget)))) && (_local_8.name == ("chat_msg_" + Std.string(_Str_13522)))))
            {
                _local_9 = cast(_local_8.widget, IIlluminaChatBubbleWidget);
            }
            if ((((_local_9 != null) && (_local_9.userId == k)) && (_arg_6 == _Str_13522)))
            {
                _local_9.appendTextMessage(_arg_4);
                this._Str_13080(null);
            }
            else
            {
                _local_8 = cast(this._chatMsg.clone(), IWidgetWindow);
                _local_8.name = ("chat_msg_" + Std.string(_arg_6));
                _local_9 = cast(_local_8.widget, IIlluminaChatBubbleWidget);
                _local_9.figure = _arg_3;
                _local_9.flipped = _arg_5;
                _local_9.message = _arg_4;
                _local_9.userName = _arg_2;
                _local_9.userId = k;
                switch (_arg_6)
                {
                    case _Str_13205:
                        _local_10 = cast(cast(_local_8.rootWindow, IWindowContainer).findChildByName("message_region"), IWindowContainer);
                        _local_10.procedure = this._Str_22682;
                        _local_10.setParamFlag(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR, true);
                        _local_10.id = ASCompat.toInt(_arg_7);
                        _local_9.underline = true;
                        
                }
                this._Str_13080(_local_8);
            }
        }

        function _Str_22682(k:WindowEvent, _arg_2:IWindow)
        {
            if (((this.disposed || (this._window == null)) || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            this._habboHelp.navigator.goToPrivateRoom(_arg_2.id);
        }

        function _Str_13080(k:IWindow)
        {
            var _local_2= cast(this._window.findChildByName("chat_list"), IItemListWindow);
            if (k != null)
            {
                _local_2.addListItemAt(k, (_local_2.numListItems - 1));
            }
            _local_2.scrollV = 1;
            _local_2.arrangeListItems();
            this._Str_21639();
        }

        function _Str_14185(k:Int, _arg_2:String)
        {
            var _local_3:IWindowContainer = null;
            if (((!this._sessionData._Str_14646()) || (_arg_2 == "")))
            {
                return;
            }
            switch (k)
            {
                case _Str_14376:
                    _local_3 = Std.downcast(this._chatMsgNotification.clone() , IWindowContainer);
                    _local_3.findChildByName("content").caption = _arg_2;
                    this._Str_13080(_local_3);
                    return;
                case _Str_13767:
                    _local_3 = Std.downcast(this._chatMsgReminder.clone() , IWindowContainer);
                    _local_3.findChildByName("content").caption = _arg_2;
                    this._Str_13080(_local_3);
                    return;
                default:
                    if (this._sessionData._Str_5935())
                    {
                        this.addChatMessage(ASCompat.toInt(this._sessionData.userId), this._sessionData.userName, this._sessionData._Str_7586, _arg_2, true, _Str_7012);
                    }
                    else
                    {
                        this.addChatMessage(ASCompat.toInt(this._sessionData._Str_5587), this._sessionData.guideName, this._sessionData.guideFigure, _arg_2, true, _Str_7012);
                    }
            }
        }

        function _Str_23250():IWidgetWindow
        {
            if (((this._window == null) || this._window.disposed))
            {
                return null;
            }
            var k= cast(this._window.findChildByName("chat_list"), IItemListWindow);
            if (k.numListItems > 1)
            {
                return Std.downcast(k.getListItemAt((k.numListItems - 2)) , IWidgetWindow);
            }
            return null;
        }

        public function onInput(k:IWidgetWindow, _arg_2:String)
        {
            if (_arg_2.length > 0)
            {
                this._habboHelp.sendMessage(new GuideSessionMessageMessageComposer(_arg_2));
                cast(k.widget, IIlluminaInputWidget).message = "";
                this._Str_21639();
            }
        }

        function _Str_10865(k:Bool)
        {
            this._onDuty = k;
            this._habboHelp.toolbar.onDuty = k;
        }

        function _Str_21639()
        {
            if (this._typingTimer != null)
            {
                this._typingTimer.stop();
                this._typingTimer = null;
            }
            if ((((this._window == null) || this._window.disposed) || ((!(this._window.name == GuideSessionStateEnum.USER_ONGOING)) && (!(this._window.name == GuideSessionStateEnum.GUIDE_ONGOING)))))
            {
                return;
            }
            this._typingTimer = new Timer(_Str_18329);
            this._typingTimer.addEventListener(TimerEvent.TIMER, (this.onTypingTimer : ASAny));
            this._typingTimer.start();
            this._lastMessageTypedLength = this.messageLength;
            this._Str_19579(false);
        }

        var messageLength(get,never):Int;
function  get_messageLength():Int
        {
            if ((((this._window == null) || this._window.disposed) || ((!(this._window.name == GuideSessionStateEnum.USER_ONGOING)) && (!(this._window.name == GuideSessionStateEnum.GUIDE_ONGOING)))))
            {
                return 0;
            }
            var k= Std.downcast(this._window.findChildByName("input_widget") , IWidgetWindow);
            return (k != null) ? cast(k.widget, IIlluminaInputWidget).message.length : 0;
        }

        function onTypingTimer(k:TimerEvent)
        {
            if ((((this._window == null) || this._window.disposed) || ((!(this._window.name == GuideSessionStateEnum.USER_ONGOING)) && (!(this._window.name == GuideSessionStateEnum.GUIDE_ONGOING)))))
            {
                return;
            }
            var _local_2= this.messageLength;
            var _local_3:ASAny = (!(this._lastMessageTypedLength == _local_2));
            if (this._lastTypingInfo != _local_3)
            {
                this._habboHelp.sendMessage(new GuideSessionIsTypingMessageComposer(_local_3));
                this._lastTypingInfo = _local_3;
            }
            this._lastMessageTypedLength = _local_2;
        }

        function _Str_19579(k:Bool)
        {
            if ((((this._window == null) || this._window.disposed) || ((!(this._window.name == GuideSessionStateEnum.USER_ONGOING)) && (!(this._window.name == GuideSessionStateEnum.GUIDE_ONGOING)))))
            {
                return;
            }
            var _local_2= cast(this._window.findChildByName("chat_list"), IItemListWindow);
            _local_2.getListItemAt((_local_2.numListItems - 1)).blend = (k ? 1 : 0);
        }

        function _Str_22173(event:TimerEvent)
        {
            var data:AnimationData = null;
            this._waitingAnimationData = ASCompat.ASVectorTools.filter(this._waitingAnimationData, function (k:AnimationData, _arg_2:Int, _arg_3:Vector<AnimationData>):Bool
            {
                return (!(k.window == null)) && (!k.window.disposed);
            });
            final _iter_ = this._waitingAnimationData; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
data  = _tmp_;
                this._Str_9300(data);
            }
        }

        function _Str_20955(k:IStaticBitmapWrapperWindow, _arg_2:String, _arg_3:Int)
        {
            if (this._window == null)
            {
                return;
            }
            var _local_4= new AnimationData(k, _arg_2, _arg_3);
            this._Str_9300(_local_4);
            this._waitingAnimationData.push(_local_4);
        }

        function _Str_9300(k:AnimationData)
        {
            var _local_2= (this._waitingAnimationTimer.currentCount % k._Str_2185);
            k.window.assetUri = ((k.asset + "_") + Std.string((_local_2 + 1)));
        }

        function _window6(window:IStaticBitmapWrapperWindow)
        {
            this._waitingAnimationData = ASCompat.ASVectorTools.filter(this._waitingAnimationData, function (k:AnimationData, _arg_2:Int, _arg_3:Vector<AnimationData>):Bool
            {
                return !(k.window == window);
            });
        }

        function _Str_3983(k:MouseEvent)
        {
            this._idleCheckLastActivity = flash.Lib.getTimer();
        }

        function _Str_19672(k:TimerEvent)
        {
            if ((this._onDuty && ((flash.Lib.getTimer() - this._idleCheckLastActivity) > (this._habboHelp.getInteger("guidetool.idle.timeout", 300) * 1000))))
            {
                this._habboHelp.sendMessage(new GuideSessionOnDutyUpdateMessageComposer(false, this._handleGuideRequests, this._handleHelperRequests, this._handleGuardianRequests));
            }
        }
    }

