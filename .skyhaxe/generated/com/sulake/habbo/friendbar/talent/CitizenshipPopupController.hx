package com.sulake.habbo.friendbar.talent
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.window.utils.IModalDialog;
    import com.sulake.habbo.communication.messages.incoming.room.engine.RoomEntryInfoMessageEvent;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.session.talent.TalentEnum;
    import com.sulake.habbo.communication.messages.outgoing.talent.GetTalentTrackMessageComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class CitizenshipPopupController implements IDisposable 
    {
        var _habboTalent:HabboTalent;
        var _dialog:IModalDialog;
        var _disposed:Bool = false;
        var _messageEvent:RoomEntryInfoMessageEvent;
        var _seenPopupDuringSession:Bool = false;

        public function new(k:HabboTalent)
        {
            this._habboTalent = k;
            this._messageEvent = new RoomEntryInfoMessageEvent(this.onRoomEnter);
            this._habboTalent.communicationManager.addHabboConnectionMessageEvent(this._messageEvent);
        }

        function onRoomEnter(k:IMessageEvent)
        {
            var _local_2:Timer = null;
            if (((this._habboTalent.newIdentity && (!this._seenPopupDuringSession)) && this._habboTalent.getBoolean("new.user.citizenship.popup.enabled")))
            {
                _local_2 = new Timer(10000, 1);
                _local_2.addEventListener(TimerEvent.TIMER, (this._Str_22885 : ASAny));
                _local_2.start();
            }
        }

        function _Str_22885(k:TimerEvent)
        {
            this._Str_14234();
            this.show();
            this._seenPopupDuringSession = true;
        }

        function _Str_14234()
        {
            if (((!(this._habboTalent == null)) && (!this._habboTalent.disposed)))
            {
                this._habboTalent.communicationManager.removeHabboConnectionMessageEvent(this._messageEvent);
            }
            this._messageEvent = null;
        }

        public function show()
        {
            this.hide();
            this._dialog = this._habboTalent.getModalXmlWindow("citizenship_welcome");
            this._dialog.rootWindow.procedure = this.onWindowEvent;
            cast(this._dialog.rootWindow, IWindowContainer).findChildByName("header_button_close").visible = false;
        }

        function hide()
        {
            if (((!(this._dialog == null)) && (!this._dialog.disposed)))
            {
                this._dialog.dispose();
                this._dialog = null;
            }
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this.hide();
                this._Str_14234();
                this._habboTalent = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function onWindowEvent(k:WindowEvent, _arg_2:IWindow)
        {
            if ((((this._dialog == null) || this._dialog.disposed) || (!(k.type == WindowMouseEvent.CLICK))))
            {
                return;
            }
            switch (_arg_2.name)
            {
                case "postpone_citizenship":
                    this.hide();
                    return;
                case "show_citizenship":
                    this.hide();
                    this._habboTalent.tracking.trackTalentTrackOpen(TalentEnum.CITIZENSHIP, "citizenshippopup");
                    this._habboTalent.send(new GetTalentTrackMessageComposer(TalentEnum.CITIZENSHIP));
                    return;
            }
        }
    }

