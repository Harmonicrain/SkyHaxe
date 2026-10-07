package com.sulake.habbo.help.guidehelp
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.help.HabboHelp;
    import com.sulake.habbo.help.GuideHelpManager;
    import com.sulake.habbo.window.utils.IModalDialog;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.help._enum._Str_2849;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habbo.communication.messages.outgoing.room.session.QuitMessageComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.window.widgets._Str_5483;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.IAvatarImageWidget;
    import com.sulake.habbo.communication.messages.parser.help.data.PendingGuideTicket;

     class HelpController implements IDisposable 
    {
        var _habboHelp:HabboHelp;
        var _guideHelp:GuideHelpManager;
        var _disposed:Bool = false;
        var _helpDialog:IModalDialog;
        var _tourPopup:IWindowContainer;
        var _tourPopupShowTime:Int = 0;
        var _pendingRequestWindow:IWindowContainer;

        public function new(k:GuideHelpManager)
        {
            this._habboHelp = k.habboHelp;
            this._guideHelp = k;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this.closeWindow();
            this._Str_13765();
            this._habboHelp = null;
            this._guideHelp = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function openWindow()
        {
            if (((this._helpDialog == null) && (!this.disposed)))
            {
                this._helpDialog = this._guideHelp.habboHelp.getModalXmlWindow("main_help");
                this._helpDialog.rootWindow.procedure = this._Str_18394;
            }
        }

        public function closeWindow()
        {
            if (this._helpDialog != null)
            {
                this._helpDialog.dispose();
                this._helpDialog = null;
            }
        }

        function _Str_18394(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3:ICheckBoxWindow = null;
            if ((this.disposed || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "header_button_close":
                    this.closeWindow();
                    return;
                case "tour_button":
                    this._guideHelp.createHelpRequest((this._habboHelp.newIdentity ? _Str_2849._Str_4268 : _Str_2849._Str_4749));
                    this._habboHelp.trackGoogle("helpWindow", "click_userTour");
                    this.closeWindow();
                    return;
                case "bully_button":
                    this.closeWindow();
                    this._habboHelp.toggleNewHelpWindow();
                    this._habboHelp.trackGoogle("helpWindow", "click_reportBully");
                    return;
                case "instructions_button":
                    this._guideHelp.createHelpRequest(_Str_2849._Str_7052);
                    this._habboHelp.trackGoogle("helpWindow", "click_instructions");
                    this.closeWindow();
                    return;
                case "self_help_link":
                    HabboWebTools.openWebPage(this._habboHelp.getProperty("zendesk.url"), "habboMain");
                    this._habboHelp.trackGoogle("helpWindow", "click_selfHelp");
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
                case "safetybooklet_link":
                    this._habboHelp.showSafetyBooklet();
                    this._habboHelp.trackGoogle("helpWindow", "click_showSafetyBooklet");
                    this.closeWindow();
                    return;
                case "emergency_button":
                    _local_3 = Std.downcast(cast(this._helpDialog.rootWindow, IWindowContainer).findChildByName("leave_room") , ICheckBoxWindow);
                    if (((!(_local_3 == null)) && _local_3.Selected))
                    {
                        this._habboHelp.sendMessage(new QuitMessageComposer());
                    }
                    this.closeWindow();
                    this._habboHelp._Str_22356();
                    this._habboHelp.trackGoogle("helpWindow", "click_emergency");
                    return;
            }
        }

        public function openTourPopup()
        {
            if (((this._tourPopup == null) && (!this.disposed)))
            {
                this._tourPopupShowTime = flash.Lib.getTimer();
                this._tourPopup = Std.downcast(this._guideHelp.habboHelp.getXmlWindow("welcome_tour_popup") , IWindowContainer);
                this._tourPopup.center();
                this._tourPopup.y = Std.int(this._tourPopup.y * 0.25);
                this._tourPopup.procedure = this._Str_23264;
            }
        }

        function _Str_13765()
        {
            if (this._tourPopup != null)
            {
                this._tourPopup.dispose();
                this._tourPopup = null;
            }
        }

        function _Str_23264(k:WindowEvent, _arg_2:IWindow)
        {
            if ((this.disposed || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            var _local_3= Std.int(((this._tourPopupShowTime - flash.Lib.getTimer()) / 1000));
            switch (_arg_2.name)
            {
                case "refuse_tour":
                    this._habboHelp.tracking.trackEventLog("Help", "", "tour.new_user.cancel", "", _local_3);
                    this._habboHelp.trackGoogle("newbieTourWindow", "click_refuseTour");
                    this._Str_13765();
                    return;
                case "header_button_close":
                    this._habboHelp.tracking.trackEventLog("Help", "", "tour.new_user.dismiss", "", _local_3);
                    this._habboHelp.trackGoogle("newbieTourWindow", "click_closeWindow");
                    this._Str_13765();
                    return;
                case "take_tour":
                    this._guideHelp.createHelpRequest(_Str_2849._Str_4268);
                    this._habboHelp.tracking.trackEventLog("Help", "", "tour.new_user.accept", "", _local_3);
                    this._habboHelp.trackGoogle("newbieTourWindow", "click_acceptTour");
                    this._Str_13765();
                    return;
            }
        }

        public function showPendingTicket(k:PendingGuideTicket)
        {
            var _local_2:String = null;
            if (k._Str_17256)
            {
                _local_2 = "pending_guide_session";
            }
            else
            {
                switch (k.type)
                {
                    case _Str_2849._Str_4268
                       | _Str_2849._Str_4749:
                        _local_2 = "pending_tour_request";
                        
                    case _Str_2849._Str_7052:
                        _local_2 = "pending_instructions_request";
                        
                    case _Str_2849._Str_8260:
                        _local_2 = "pending_bully_request";
                        
                    default:
                        return;
                }
            }
            this._pendingRequestWindow = Std.downcast(this._habboHelp.getXmlWindow(_local_2) , IWindowContainer);
            this._pendingRequestWindow.center();
            this._pendingRequestWindow.procedure = this.onPendingReuqestEvent;
            if (k._Str_17256)
            {
                return;
            }
            switch (k.type)
            {
                case _Str_2849._Str_7052:
                    this._pendingRequestWindow.findChildByName("description").caption = k.description;
                    cast(cast(this._pendingRequestWindow.findChildByName("timestamp"), IWidgetWindow).widget, _Str_5483).timeStamp = (Date.now().getTime() - (k._Str_20952 * 1000));
                    return;
                case _Str_2849._Str_8260:
                    this._pendingRequestWindow.findChildByName("user_name").caption = k._Str_25260;
                    cast(cast(this._pendingRequestWindow.findChildByName("user_avatar"), IWidgetWindow).widget, IAvatarImageWidget).figure = k._Str_25026;
                    cast(cast(this._pendingRequestWindow.findChildByName("timestamp"), IWidgetWindow).widget, _Str_5483).timeStamp = (Date.now().getTime() - (k._Str_20952 * 1000));
                    this._habboHelp.localization.registerParameter("guide.pending.bully.room", "room", k.roomName);
                    return;
            }
        }

        function onPendingReuqestEvent(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "header_button_close"
                       | "close_button":
                        if (((!(this._pendingRequestWindow == null)) && (!this._pendingRequestWindow.disposed)))
                        {
                            this._pendingRequestWindow.dispose();
                            this._pendingRequestWindow = null;
                        }
                        return;
                }
            }
        }
    }

