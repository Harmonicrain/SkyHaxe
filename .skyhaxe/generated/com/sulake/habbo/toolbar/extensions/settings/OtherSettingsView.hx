package com.sulake.habbo.toolbar.extensions.settings
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.toolbar.HabboToolbar;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.ICheckBoxWindow;
    import com.sulake.habbo.phonenumber.PhoneNumberStatusEnum;
    import com.sulake.habbo.phonenumber.ClientPhoneVerificationStatusEnum;
    import com.sulake.habbo.communication.messages.outgoing.preferences.SetIgnoreRoomInvitesMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.preferences.SetRoomCameraPreferencesMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.gifts.ResetPhoneNumberStateMessageComposer;
    import com.sulake.habbo.session.events.PerksUpdatedEvent;
    import com.sulake.habbo.communication._enum.perk.PerkEnum;

     class OtherSettingsView 
    {
        var _window:IWindowContainer;
        var _toolbar:HabboToolbar;
        var _reopenNavigatorOnPerksUpdated:Bool = false;
        var _reopenNavigatorUseNew:Bool = false;

        public function new(k:HabboToolbar)
        {
            this._toolbar = k;
            this.createWindow();
        }

        public function dispose()
        {
            if (this._window == null)
            {
                return;
            }
            this._toolbar.sessionDataManager.events.removeEventListener(PerksUpdatedEvent.PERKS_UPDATED, this.onPerksUpdated);
            this._reopenNavigatorOnPerksUpdated = false;
            this._reopenNavigatorUseNew = false;
            this._window.dispose();
            this._window = null;
        }

        function createWindow()
        {
            var k= Std.downcast(this._toolbar.assets.getAssetByName("me_menu_other_settings_xml") , XmlAsset);
            this._window = Std.downcast(this._toolbar.windowManager.buildFromXML(((k.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            var _local_2 = 0;
            var _local_3:IWindow = null;
            while (_local_2 < this._window.numChildren)
            {
                _local_3 = this._window.getChildAt(_local_2);
                _local_3.addEventListener(WindowMouseEvent.CLICK, this.onButtonClicked);
                _local_2++;
            }
            cast(this._window.findChildByName("prefer_old_chat_checkbox"), ICheckBoxWindow).Selected = this._toolbar.freeFlowChat.isDisabledInPreferences;
            cast(this._window.findChildByName("ignore_room_invites_checkbox"), ICheckBoxWindow).Selected = this._toolbar.messenger.getRoomInvitesIgnored();
            cast(this._window.findChildByName("use_new_navigator_checkbox"), ICheckBoxWindow).Selected = this._toolbar.sessionDataManager.isNavigatorPhaseTwo;
            this._window.findChildByName("disable_room_camera_follow_checkbox").visible = (this._window.findChildByName("disable_room_camera_follow_label").visible = this._toolbar.getBoolean("room.camera.follow_user"));
            if (this._toolbar.getBoolean("room.camera.follow_user"))
            {
                cast(this._window.findChildByName("disable_room_camera_follow_checkbox"), ICheckBoxWindow).Selected = this._toolbar.sessionDataManager.isRoomCameraFollowDisabled;
            }
            var _local_4= this._toolbar.getBoolean("sms.identity.verification.enabled");
            var _local_5:ASAny = (this._toolbar.getInteger("phone.verification.status", PhoneNumberStatusEnum.NON_EXISTING) == PhoneNumberStatusEnum.VERIFIED);
            var _local_6:ASAny = (this._toolbar.getInteger("phone.collection.status", ClientPhoneVerificationStatusEnum.NON_EXISTING) == ClientPhoneVerificationStatusEnum.NEVER_AGAIN);
            var _local_7= this._toolbar.getBoolean("sms.identity.verification.button.enabled");
            var _local_8:ASAny = (this._toolbar.getInteger("phone.collection.status", ClientPhoneVerificationStatusEnum.NON_EXISTING) == ClientPhoneVerificationStatusEnum.NON_EXISTING);
            var _local_9= ((_local_4 && (!_local_5)) && (ASCompat.toBool(_local_6) || (_local_7 && ASCompat.toBool(_local_8))));
            this._window.findChildByName("btn_reset_phone_number_collection").visible = _local_9;
        }

        function onButtonClicked(k:WindowMouseEvent)
        {
            var _local_5 = false;
            var _local_4 = false;
            var _local_2= k.target ;
            var _local_3= _local_2.name;
            switch (_local_3)
            {
                case "back_btn":
                    this.dispose();
                    return;
                case "prefer_old_chat_checkbox":
                    this._toolbar.freeFlowChat.isDisabledInPreferences = cast(this._window.findChildByName("prefer_old_chat_checkbox"), ICheckBoxWindow).Selected;
                    if (!this._toolbar.freeFlowChat.isDisabledInPreferences)
                    {
                        if (((!(this._toolbar._Str_12052.chatContainer == null)) && (!(this._toolbar.freeFlowChat.displayObject == null))))
                        {
                            this._toolbar._Str_12052.chatContainer.setDisplayObject(this._toolbar.freeFlowChat.displayObject);
                        }
                    }
                    else
                    {
                        this._toolbar.freeFlowChat.clear();
                    }
                    return;
                case "ignore_room_invites_checkbox":
                    this._toolbar.messenger.setRoomInvitesIgnored(cast(this._window.findChildByName("ignore_room_invites_checkbox"), ICheckBoxWindow).Selected);
                    this._toolbar.connection.send(new SetIgnoreRoomInvitesMessageComposer(this._toolbar.messenger.getRoomInvitesIgnored()));
                    return;
                case "use_new_navigator_checkbox":
                    _local_4 = cast(this._window.findChildByName("use_new_navigator_checkbox"), ICheckBoxWindow).Selected;
                    this._toolbar.sessionDataManager.events.removeEventListener(PerksUpdatedEvent.PERKS_UPDATED, this.onPerksUpdated);
                    this._reopenNavigatorOnPerksUpdated = false;
                    _local_5 = this._toolbar.sessionDataManager.setNavigatorPhaseTwo(_local_4);
                    if (_local_5)
                    {
                        this._reopenNavigatorOnPerksUpdated = true;
                        this._reopenNavigatorUseNew = _local_4;
                        this._toolbar.sessionDataManager.events.addEventListener(PerksUpdatedEvent.PERKS_UPDATED, this.onPerksUpdated);
                    }
                    return;
                case "disable_room_camera_follow_checkbox":
                    _local_4 = cast(this._window.findChildByName("disable_room_camera_follow_checkbox"), ICheckBoxWindow).Selected;
                    this._toolbar.connection.send(new SetRoomCameraPreferencesMessageComposer(_local_4));
                    this._toolbar.sessionDataManager.setRoomCameraFollowDisabled(_local_4);
                    return;
                case "btn_reset_phone_number_collection":
                    this._window.findChildByName("btn_reset_phone_number_collection").visible = false;
                    this._toolbar.connection.send(new ResetPhoneNumberStateMessageComposer());
                    return;
            }
        }

        function onPerksUpdated(k:PerksUpdatedEvent)
        {
            this._toolbar.sessionDataManager.events.removeEventListener(PerksUpdatedEvent.PERKS_UPDATED, this.onPerksUpdated);
            if (!this._reopenNavigatorOnPerksUpdated)
            {
                return;
            }
            this._reopenNavigatorOnPerksUpdated = false;
            if (this._reopenNavigatorUseNew)
            {
                if (this._toolbar.sessionDataManager.isPerkAllowed(PerkEnum.NAVIGATOR_PHASE_TWO_2014))
                {
                    this._toolbar.openNewNavigator();
                }
                return;
            }
            if (!this._toolbar.sessionDataManager.isPerkAllowed(PerkEnum.NAVIGATOR_PHASE_TWO_2014))
            {
                this._toolbar.navigator.openNavigator();
            }
        }

        public var window(get,never):IWindowContainer;
public function  get_window():IWindowContainer
        {
            return this._window;
        }
    }




