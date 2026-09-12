package com.sulake.habbo.help
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.help.guidehelp.HelpController;
    import com.sulake.habbo.help.guidehelp.GuideSessionController;
    import flash.utils.Timer;
    import com.sulake.habbo.communication.messages.incoming.room.engine.RoomEntryInfoMessageEvent;
    import flash.events.TimerEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.data.PendingGuideTicket;
    import com.sulake.habbo.toolbar.events.HabboToolbarEvent;
    import com.sulake.habbo.toolbar.HabboToolbarIconEnum;

     class GuideHelpManager implements IDisposable 
    {
        var _habboHelp:HabboHelp;
        var _guideHelpController:HelpController;
        var _guideSessionController:GuideSessionController;
        var _chatReviewReporterFeedbackCtrl:ChatReviewReporterFeedbackCtrl;
        var _disposed:Bool = false;
        var _seenTourPopupDuringSession:Bool = false;
        var _panicRoomId:Int = 0;
        var _panicRoomName:String;
        var _popupTimer:Timer;

        public function new(k:HabboHelp)
        {
            this._habboHelp = k;
            this._guideHelpController = new HelpController(this);
            this._guideSessionController = new GuideSessionController(this);
            this._chatReviewReporterFeedbackCtrl = new ChatReviewReporterFeedbackCtrl(this._habboHelp);
            this._habboHelp.communicationManager.addHabboConnectionMessageEvent(new RoomEntryInfoMessageEvent(this.onRoomEnter));
        }

        public var habboHelp(get,never):HabboHelp;
public function  get_habboHelp():HabboHelp
        {
            return this._habboHelp;
        }

        function onRoomEnter(k:IMessageEvent)
        {
            if ((((this._habboHelp._Str_19829 && this._habboHelp.newIdentity) && (!this._seenTourPopupDuringSession)) && (!this._habboHelp.sessionDataManager.isRealNoob)))
            {
                this._popupTimer = new Timer(this.getTourPopupDelay(), 1);
                this._popupTimer.addEventListener(TimerEvent.TIMER, (this.onTourPopup : ASAny));
                this._popupTimer.start();
                this._habboHelp.tracking.trackEventLog("Help", "", "tour.new_user.create", "", this.getTourPopupDelay());
                this._habboHelp.trackGoogle("newbieTourWindow", "timer_popupCreated");
            }
        }

        function onTourPopup(k:TimerEvent)
        {
            if (this._disposed)
            {
                return;
            }
            this._habboHelp.tracking.trackEventLog("Help", "", "tour.new_user.show", "", this.getTourPopupDelay());
            this._habboHelp.trackGoogle("newbieTourWindow", "timer_popupShown");
            this.openTourPopup();
        }

        public function openTourPopup()
        {
            this._guideHelpController.openTourPopup();
            this._seenTourPopupDuringSession = true;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            if (this._guideHelpController != null)
            {
                this._guideHelpController.dispose();
                this._guideHelpController = null;
            }
            if (this._guideSessionController != null)
            {
                this._guideSessionController.dispose();
                this._guideSessionController = null;
            }
            if (this._chatReviewReporterFeedbackCtrl != null)
            {
                this._chatReviewReporterFeedbackCtrl.dispose();
                this._chatReviewReporterFeedbackCtrl = null;
            }
            if (this._popupTimer != null)
            {
                this._popupTimer.reset();
                this._popupTimer = null;
            }
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function showGuideTool()
        {
            this._guideSessionController.showGuideTool();
        }

        public function showPendingTicket(k:PendingGuideTicket)
        {
            this._guideHelpController.showPendingTicket(k);
        }

        public function createHelpRequest(k:UInt)
        {
            this._guideSessionController.createHelpRequest(k);
        }

        public function openReportWindow()
        {
            this._guideSessionController.openReportWindow();
        }

        public function showFeedback(k:String)
        {
            this._chatReviewReporterFeedbackCtrl.show(k);
        }

        function getTourPopupDelay():Int
        {
            return this._habboHelp.getInteger("guide.help.new.user.tour.popup.delay", 30) * 1000;
        }

        public function onHabboToolbarEvent(k:HabboToolbarEvent)
        {
            if (k.type == HabboToolbarEvent.HTE_TOOLBAR_CLICK)
            {
                switch (k.iconId)
                {
                    case HabboToolbarIconEnum.HELP:
                        this._habboHelp.toggleNewHelpWindow();
                        return;
                    case HabboToolbarIconEnum.GUIDE:
                        this.showGuideTool();
                        return;
                }
            }
        }
    }

