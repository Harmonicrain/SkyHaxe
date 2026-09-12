package com.sulake.habbo.groups
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.groups.badge.BadgeEditorCtrl;
    import com.sulake.habbo.communication.messages.incoming.users.IGuildData;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.incoming.users.RoomEntryData;
    import com.sulake.core.window.IWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.communication.messages.incoming.users.GuildColorData;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.communication.messages.incoming.users.GuildCreationData;
    import com.sulake.core.window.components.ITabContextWindow;
    import com.sulake.core.window.components.ISelectableWindow;
    import com.sulake.habbo.communication.messages.incoming.users.GuildEditData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.users.GetGuildMembersMessageComposer;
    import com.sulake.habbo.window.utils.IAlertDialog;
    import com.sulake.core.window.components.ITextFieldWindow;
    import com.sulake.habbo.communication.messages.outgoing.users.UpdateGuildIdentityMessageComposer;
    import com.sulake.habbo.groups.events.GuildSettingsChangedInManageEvent;
    import com.sulake.habbo.communication.messages.outgoing.users.UpdateGuildBadgeMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.UpdateGuildColorsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.UpdateGuildSettingsMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.users.CreateGuildMessageComposer;
    import com.sulake.core.window.components.IDropMenuWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;

     class GuildManagementWindowCtrl implements IDisposable 
    {
        static inline final VIEW_IDENTITY= 1;
        static inline final VIEW_BADGE= 2;
        static inline final VIEW_COLORS= 3;
        static inline final VIEW_CONFIRM= 4;
        static inline final VIEW_SETTINGS= 5;
        static inline final HEADER_CAPTION_Y_CREATE= 43;
        static inline final HEADER_INFO_Y_CREATE= 69;
        static inline final EDIT_HEADER_TEXTS_OFFSET= -20;
        static inline final CREATE_HEADER_BITMAP_OFFSET= 36;
        static inline final STEP_TITLE_Y_OFFSET_ACTIVE= 5;
        static inline final STEP_TITLE_Y_OFFSET_INACTIVE= 9;
        static inline final STEP_TITLE_CREDIT_Y_OFFSET_ACTIVE= 6;
        static inline final STEP_TITLE_CREDIT_Y_OFFSET_INACTIVE= 10;
        static inline final MAX_DESCRIPTION_LENGTH= 0xFF;
        static inline final MAX_NAME_LENGTH= 30;

        var _manager:HabboGroupsManager;
        var _window:IWindowContainer;
        var _badgeEditorCtrl:BadgeEditorCtrl;
        var _primaryColorCtrl:ColorGridCtrl;
        var _secondaryColorCtrl:ColorGridCtrl;
        var _settingsCtrl:GuildSettingsCtrl;
        var _alertVisible:Bool = false;
        var _alertedBaseRoomId:Int = 0;
        var _data:IGuildData;
        var _step:Int = 1;

        public function new(k:HabboGroupsManager)
        {
            this._manager = k;
            this._badgeEditorCtrl = new BadgeEditorCtrl(this._manager);
            this._primaryColorCtrl = new ColorGridCtrl(this._manager, this.onPrimaryColorSelected);
            this._secondaryColorCtrl = new ColorGridCtrl(this._manager, this.onSecondaryColorSelected);
            this._settingsCtrl = new GuildSettingsCtrl();
        }

        public function dispose()
        {
            this._manager = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._badgeEditorCtrl != null)
            {
                this._badgeEditorCtrl.dispose();
                this._badgeEditorCtrl = null;
            }
            if (this._primaryColorCtrl != null)
            {
                this._primaryColorCtrl.dispose();
                this._primaryColorCtrl = null;
            }
            if (this._secondaryColorCtrl != null)
            {
                this._secondaryColorCtrl.dispose();
                this._secondaryColorCtrl = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._manager == null;
        }

        function prepare()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = cast(this._manager.getXmlWindow("group_management_window"), IFrameWindow);
            this._window.findChildByTag("close").procedure = this.onCloseWindow;
            this._window.center();
            this._window.findChildByName("create_room_link_region").procedure = this.onCreateRoomLink;
            this._window.findChildByName("cancel_link_region").procedure = this.onCancelLink;
            this._window.findChildByName("next_step_button").procedure = this.onNextStep;
            this._window.findChildByName("previous_step_link_region").procedure = this.onPreviousStep;
            this._window.findChildByName("buy_button").procedure = this.onBuy;
            this._window.findChildByName("vip_required_region").procedure = this.onGetVip;
            this._window.addEventListener(WindowEvent.WINDOW_EVENT_DEACTIVATED, this.onWindowUnActivated);
            this._window.findChildByName("edit_tab_1").procedure = this.onTab;
            this._window.findChildByName("edit_tab_2").procedure = this.onTab;
            this._window.findChildByName("edit_tab_3").procedure = this.onTab;
            this._window.findChildByName("edit_tab_5").procedure = this.onTab;
            this._window.findChildByName("reset_badge").procedure = this.onBadgeReset;
            this._window.findChildByName("reset_colors").procedure = this.onColorReset;
            this._window.findChildByName("step_1_members_region").procedure = this.onMembersClick;
            this._settingsCtrl.prepare(this._window);
        }

        public function onFlatCreated(k:Int, _arg_2:String)
        {
            if (((((!(this._window == null)) && this._window.visible) && (!(this._data == null))) && (!this._data.exists)))
            {
                this._data.ownedRooms.insert(0, new RoomEntryData(k, _arg_2, false));
                this.prepareRoomSelection();
                this.getBaseDropMenu().selection = 0;
            }
        }

        public function onSubscriptionChange()
        {
            if ((((((!(this._window == null)) && this._window.visible) && (!(this._data == null))) && (!this._data.exists)) && (this._step == VIEW_CONFIRM)))
            {
                this.refresh();
            }
        }

        public function refresh()
        {
            var _local_3:IWindow = null;
            this.prepare();
            var k= ((!this._data.exists) || this._data.isOwner);
            this._window.findChildByName("edit_tab_1").visible = k;
            this._window.findChildByName("edit_tab_2").visible = k;
            this._window.findChildByName("edit_tab_3").visible = k;
            this._window.findChildByName("edit_tab_5").visible = k;
            var _local_2= 1;
            while (_local_2 <= VIEW_SETTINGS)
            {
                this.getStepContainer(_local_2).visible = (this._step == _local_2);
                _local_3 = this._window.findChildByName(("header_pic_bitmap_step_" + Std.string(_local_2)));
                _local_3.y = (this._data.exists ? 0 : CREATE_HEADER_BITMAP_OFFSET);
                _local_3.visible = (this._step == _local_2);
                _local_2++;
            }
            this._window.findChildByName("header_caption_txt").caption = this.getStepCaption();
            this._window.findChildByName("header_desc_txt").caption = this.getStepDesc();
            this._window.findChildByName("header_pic_bitmap");
            this._window.findChildByName("header_caption_txt").y = (HEADER_CAPTION_Y_CREATE + this.getHeaderTextOffset());
            this._window.findChildByName("header_desc_txt").y = (HEADER_INFO_Y_CREATE + this.getHeaderTextOffset());
            this._window.findChildByName("edit_guild_tab_context").visible = this._data.exists;
            this._window.findChildByName("footer_cont").visible = (!this._data.exists);
            this._window.findChildByName("reset_badge").visible = false;
            this._window.findChildByName("reset_colors").visible = false;
            if (this._step == VIEW_BADGE)
            {
                if (!this._data.exists)
                {
                    this._manager.trackGoogle("groupPurchase", "step2_badge");
                }
                if (!this._badgeEditorCtrl.isIntialized)
                {
                    this._badgeEditorCtrl.createWindow(this.getStepContainer(VIEW_BADGE), this._data.badgeSettings);
                    this._badgeEditorCtrl._Str_15567(this._data.badgeSettings);
                }
                this._window.findChildByName("reset_badge").visible = this._data.exists;
            }
            if (this._step == VIEW_COLORS)
            {
                if (!this._data.exists)
                {
                    this._manager.trackGoogle("groupPurchase", "step3_colors");
                }
                if (!this._primaryColorCtrl.isInitialized)
                {
                    this._primaryColorCtrl._Str_16890(this.getStepContainer(VIEW_COLORS), "guild_primary_color_selector", this._manager.guildEditorData._Str_17665);
                    if (this._data.exists)
                    {
                        this._primaryColorCtrl._Str_6434(this._data.primaryColorId);
                    }
                    else
                    {
                        this._primaryColorCtrl._Str_6434(this._manager.guildEditorData.findMatchingPrimaryColorId(this._badgeEditorCtrl._Str_23897));
                    }
                }
                if (!this._secondaryColorCtrl.isInitialized)
                {
                    this._secondaryColorCtrl._Str_16890(this.getStepContainer(VIEW_COLORS), "guild_secondary_color_selector", this._manager.guildEditorData._Str_16298);
                    if (this._data.exists)
                    {
                        this._secondaryColorCtrl._Str_6434(this._data.secondaryColorId);
                    }
                    else
                    {
                        this._secondaryColorCtrl._Str_6434(this._manager.guildEditorData.findMatchingSecondaryColorId(this._badgeEditorCtrl._Str_24812));
                    }
                }
                this._window.findChildByName("reset_colors").visible = this._data.exists;
            }
            if (this._step == VIEW_SETTINGS)
            {
                if (!this._settingsCtrl.isInitialized)
                {
                    this._settingsCtrl.refresh(this._data);
                }
            }
            if (this._step == VIEW_CONFIRM)
            {
                if (!this._data.exists)
                {
                    this._manager.trackGoogle("groupPurchase", "step4_confirm");
                }
                this.updateConfirmPreview();
            }
            if (this._step == VIEW_IDENTITY)
            {
                if (!this._data.exists)
                {
                    this._manager.trackGoogle("groupPurchase", "step1_identity");
                }
                else
                {
                    this._manager.windowManager.registerLocalizationParameter("group.membercount", "totalMembers", ("" + Std.string(this._data.membershipCount)));
                    this._window.findChildByName("step_1_members_txt").caption = this._manager.localization.getLocalization("group.membercount");
                }
                this._window.findChildByName("base_label").visible = (!this._data.exists);
                this._window.findChildByName("base_dropmenu").visible = (!this._data.exists);
                this._window.findChildByName("base_warning").visible = (!this._data.exists);
                this._window.findChildByName("create_room_link_region").visible = (!this._data.exists);
                this._window.findChildByName("step_1_members_region").visible = this.data.exists;
            }
            this.refreshCreateHeader();
        }

        function updateConfirmPreview()
        {
            var k:BitmapData = null;
            var _local_2:IBitmapWrapperWindow = null;
            var _local_3:GuildColorData = null;
            var _local_4:IWindow = null;
            var _local_5:GuildColorData = null;
            var _local_6:IWindow = null;
            if (((this._manager.guildEditorData == null) || (this._window == null)))
            {
                return;
            }
            if (this._badgeEditorCtrl.isIntialized)
            {
                k = this._badgeEditorCtrl._Str_23597();
                _local_2 = Std.downcast(this._window.findChildByName("badge_preview_image") , IBitmapWrapperWindow);
                if (((!(k == null)) && (!(_local_2 == null))))
                {
                    _local_2.bitmap = k;
                }
            }
            if (this._primaryColorCtrl.isInitialized)
            {
                _local_3 = this._primaryColorCtrl._Str_10058();
                _local_4 = this._window.findChildByName("badge_preview_primary_color_top");
                if (((!(_local_3 == null)) && (!(_local_4 == null))))
                {
                    _local_4.color = _local_3.color;
                }
            }
            if (this._secondaryColorCtrl.isInitialized)
            {
                _local_5 = this._secondaryColorCtrl._Str_10058();
                _local_6 = this._window.findChildByName("badge_preview_secondary_color_top");
                if (((!(_local_5 == null)) && (!(_local_6 == null))))
                {
                    _local_6.color = _local_5.color;
                }
            }
            if (this._manager.hasVip)
            {
                this._window.findChildByName("buy_button").enable();
                this._window.findChildByName("buy_border").color = 0xFFC300;
            }
            else
            {
                this._window.findChildByName("buy_border").color = 0xAAAAAA;
                this._window.findChildByName("buy_button").disable();
            }
            this._window.findChildByName("vip_required_border").visible = (!this._manager.hasVip);
            this._window.findChildByName("confirmation_caption").caption = cast(this._window.findChildByName("name_txt"), ITextWindow).text;
        }

        function getHeaderTextOffset():Int
        {
            return this._data.exists ? EDIT_HEADER_TEXTS_OFFSET : 0;
        }

        function refreshCreateHeader()
        {
            this._window.findChildByName("steps_header_cont").visible = (!this._data.exists);
            if (this._data.exists)
            {
                return;
            }
            this._window.findChildByName("next_step_button").visible = this.hasNextStep();
            this._window.findChildByName("previous_step_link_region").visible = this.hasPreviousStep();
            this._window.findChildByName("cancel_link_region").visible = (!this.hasPreviousStep());
            this._window.findChildByName("buy_border").visible = (!this.hasNextStep());
            var k= 1;
            while (k <= VIEW_CONFIRM)
            {
                this.getStepHeader(k, false).visible = (!(k == this._step));
                this.getStepHeader(k, true).visible = (k == this._step);
                this._window.findChildByName(("step_title_" + Std.string(k))).y = ((k == this._step) ? STEP_TITLE_Y_OFFSET_ACTIVE : STEP_TITLE_Y_OFFSET_INACTIVE);
                k++;
            }
            this._window.findChildByName("gcreate_icon_credit").y = ((this._step == VIEW_CONFIRM) ? STEP_TITLE_CREDIT_Y_OFFSET_ACTIVE : STEP_TITLE_CREDIT_Y_OFFSET_INACTIVE);
        }

        function getStepHeader(k:Int, _arg_2:Bool):IWindow
        {
            return this._window.findChildByName(((("gcreate_" + Std.string(k)) + "_") + (_arg_2 ? "1" : "0")));
        }

        function getStepContainer(k:Int):IWindowContainer
        {
            return cast(this._window.findChildByName(("step_cont_" + Std.string(k))), IWindowContainer);
        }

        function getStepCaption():String
        {
            var k= ((this._data.exists ? "group.edit.tabcaption." : "group.create.stepcaption.") + Std.string(this._step));
            return this._manager.localization.getLocalization(k, k);
        }

        function getStepDesc():String
        {
            var k= ((this._data.exists ? "group.edit.tabdesc." : "group.create.stepdesc.") + Std.string(this._step));
            return this._manager.localization.getLocalization(k, k);
        }

        public function onGuildCreationInfo(k:GuildCreationData)
        {
            this._data = k;
            this._step = VIEW_IDENTITY;
            this._alertedBaseRoomId = 0;
            this.refresh();
            this.refreshBadgeImage();
            this.setupInputs();
            this._manager.localization.registerParameter("group.create.confirm.buyinfo", "amount", ("" + Std.string(k.costInCredits)));
            this._window.visible = true;
            this._window.activate();
        }

        public function onGuildEditInfo(k:GuildEditData)
        {
            this._data = k;
            this._step = VIEW_IDENTITY;
            this._alertedBaseRoomId = 0;
            this.refresh();
            this.refreshBadgeImage();
            this.setupInputs();
            var _local_2= cast(this._window.findChildByName("edit_guild_tab_context"), ITabContextWindow);
            var _local_3= cast(this._window.findChildByName(("edit_tab_" + Std.string(this._step))), ISelectableWindow);
            _local_2.selector.setSelected(_local_3);
            this._window.visible = true;
            this._window.activate();
        }

        function setupInputs()
        {
            cast(this._window.findChildByName("name_txt"), ITextWindow).text = this._data.groupName;
            cast(this._window.findChildByName("desc_txt"), ITextWindow).text = this._data.groupDesc;
            this.prepareRoomSelection();
            this._badgeEditorCtrl._Str_15567(this._data.badgeSettings);
            this._primaryColorCtrl._Str_6434(this._data.primaryColorId);
            this._secondaryColorCtrl._Str_6434(this._data.secondaryColorId);
            this._settingsCtrl.refresh(this._data);
        }

        function onTab(k:WindowEvent, _arg_2:IWindow)
        {
            if (((!(k.type == WindowEvent.WINDOW_EVENT_SELECT)) || (_arg_2.id == this._step)))
            {
                return;
            }
            if (!this.validateView())
            {
                k.preventDefault();
                return;
            }
            this.saveView();
            this._step = _arg_2.id;
            this.refresh();
        }

        function onColorReset(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                if (this._primaryColorCtrl.isInitialized)
                {
                    this._primaryColorCtrl._Str_6434(this._data.primaryColorId);
                }
                if (this._secondaryColorCtrl.isInitialized)
                {
                    this._secondaryColorCtrl._Str_6434(this._data.secondaryColorId);
                }
            }
        }

        function onBadgeReset(k:WindowEvent, _arg_2:IWindow)
        {
            if (((k.type == WindowMouseEvent.CLICK) && this._badgeEditorCtrl.isIntialized))
            {
                this._badgeEditorCtrl._Str_15567(this._data.badgeSettings);
            }
        }

        function onMembersClick(k:WindowEvent, _arg_2:IWindow)
        {
            if ((((k.type == WindowMouseEvent.CLICK) && this._data.exists) && (!(this._manager.guildMembersWindowCtrl == null))))
            {
                this._manager.trackGoogle("groupManagement", "groupMembers");
                this._manager.guildMembersWindowCtrl.onMembersClick(this._data.groupId, GetGuildMembersMessageComposer._Str_13464);
            }
        }

        function onCancelLink(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.close();
        }

        function onCreateRoomLink(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._manager.navigator.startRoomCreation();
        }

        function onNextStep(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if (!this.validateView())
            {
                return;
            }
            this._step = this.limitStep((this._step + 1));
            this.refresh();
        }

        function onPreviousStep(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if (!this.validateView())
            {
                return;
            }
            this._step = this.limitStep((this._step - 1));
            this.refresh();
        }

        function onBuy(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if (!this._data.exists)
            {
                this._manager.trackGoogle("groupPurchase", "buyGroup");
            }
            this.sendCreateGuildMessage();
        }

        function onGetVip(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if (!this._data.exists)
            {
                this._manager.trackGoogle("groupPurchase", "buyVip");
            }
            this._manager.openVipPurchase("GuildManagementWindowCtrl");
        }

        function showAlert(k:String, _arg_2:String)
        {
            if (!this._alertVisible)
            {
                this._alertVisible = true;
                this._manager.windowManager.alert(k, _arg_2, 0, this.onAlertClose);
            }
        }

        function onAlertClose(k:IAlertDialog, _arg_2:WindowEvent)
        {
            k.dispose();
            this._alertVisible = false;
        }

        function validateView():Bool
        {
            var k:String = null;
            var _local_2:String = null;
            var _local_3:Array<ASAny> = null;
            var _local_4:RoomEntryData = null;
            switch (this._step)
            {
                case VIEW_IDENTITY:
                    k = cast(this._window.findChildByName("name_txt"), ITextFieldWindow).text;
                    if (!this._data.exists)
                    {
                        _local_4 = this.resolveBaseRoom();
                        if (((((k == null) || (k.length == 0)) || (_local_4 == null)) || (_local_4.roomId == 0)))
                        {
                            this.showAlert("${group.edit.error.title}", "${group.edit.error.no.name.or.room.selected}");
                            return false;
                        }
                        if ((_local_4._Str_22776 && (!(this._alertedBaseRoomId == _local_4.roomId))))
                        {
                            this._alertedBaseRoomId = _local_4.roomId;
                            this.showAlert("${group.edit.error.warning}", "${group.edit.error.controllers}");
                            return false;
                        }
                    }
                    if (k.length >= MAX_NAME_LENGTH)
                    {
                        this.showAlert("${group.edit.error.title}", "${group.edit.error.name.length}");
                        return false;
                    }
                    _local_2 = cast(this._window.findChildByName("desc_txt"), ITextFieldWindow).text;
                    if (((!(_local_2 == null)) && (_local_2.length >= MAX_DESCRIPTION_LENGTH)))
                    {
                        this.showAlert("${group.edit.error.title}", "${group.edit.error.desc.length}");
                        return false;
                    }
                    return true;
                case VIEW_BADGE:
                    _local_3 = (this._badgeEditorCtrl.isIntialized ? this._badgeEditorCtrl.getBadgeSettings() : this._data.badgeSettings);
                    this._badgeEditorCtrl._Str_23176();
                    return true;
                case VIEW_COLORS:
                    if (((this._primaryColorCtrl._Str_10058() == null) || (this._secondaryColorCtrl._Str_10058() == null)))
                    {
                        this.showAlert("${group.edit.error.title}", "${group.edit.error.no.color.selected}");
                        return false;
                    }
                    return true;
                default:
                    return true;
            }
        }

        function saveView()
        {
            var k:String = null;
            var _local_2:String = null;
            var _local_3:Array<ASAny> = null;
            var _local_4 = 0;
            var _local_5 = 0;
            switch (this._step)
            {
                case VIEW_IDENTITY:
                    k = cast(this._window.findChildByName("name_txt"), ITextFieldWindow).text;
                    _local_2 = cast(this._window.findChildByName("desc_txt"), ITextFieldWindow).text;
                    this._manager.send(new UpdateGuildIdentityMessageComposer(this._data.groupId, k, _local_2));
                    this._manager.events.dispatchEvent(new GuildSettingsChangedInManageEvent(GuildSettingsChangedInManageEvent.GSCIME_GUILD_VISUAL_SETTINGS_CHANGED, this._data.groupId));
                    return;
                case VIEW_BADGE:
                    _local_3 = (this._badgeEditorCtrl.isIntialized ? this._badgeEditorCtrl.getBadgeSettings() : this._data.badgeSettings);
                    this._manager.send(new UpdateGuildBadgeMessageComposer(this._data.groupId, _local_3));
                    this._manager.events.dispatchEvent(new GuildSettingsChangedInManageEvent(GuildSettingsChangedInManageEvent.GSCIME_GUILD_VISUAL_SETTINGS_CHANGED, this._data.groupId));
                    return;
                case VIEW_COLORS:
                    _local_4 = (this._primaryColorCtrl.isInitialized ? this._primaryColorCtrl._Str_15044() : this._data.primaryColorId);
                    _local_5 = (this._secondaryColorCtrl.isInitialized ? this._secondaryColorCtrl._Str_15044() : this._data.secondaryColorId);
                    this._manager.send(new UpdateGuildColorsMessageComposer(this._data.groupId, _local_4, _local_5));
                    this._manager.events.dispatchEvent(new GuildSettingsChangedInManageEvent(GuildSettingsChangedInManageEvent.GSCIME_GUILD_VISUAL_SETTINGS_CHANGED, this._data.groupId));
                    return;
                case VIEW_SETTINGS:
                    this._manager.send(new UpdateGuildSettingsMessageComposer(this._data.groupId, this._settingsCtrl.guildType, this._settingsCtrl._Str_7959));
                    this._settingsCtrl._Str_15948();
                    return;
            }
        }

        function sendCreateGuildMessage()
        {
            var k= cast(this._window.findChildByName("name_txt"), ITextFieldWindow).text;
            var _local_2= cast(this._window.findChildByName("desc_txt"), ITextFieldWindow).text;
            var _local_3= this.resolveBaseRoom();
            var _local_4= (this._badgeEditorCtrl.isIntialized ? this._badgeEditorCtrl.getBadgeSettings() : this._data.badgeSettings);
            var _local_5= (this._primaryColorCtrl.isInitialized ? this._primaryColorCtrl._Str_15044() : this._data.primaryColorId);
            var _local_6= (this._secondaryColorCtrl.isInitialized ? this._secondaryColorCtrl._Str_15044() : this._data.secondaryColorId);
            this._alertedBaseRoomId = 0;
            this._manager.send(new CreateGuildMessageComposer(k, _local_2, _local_3.roomId, _local_5, _local_6, _local_4));
        }

        function hasPreviousStep():Bool
        {
            return !(this._step == this.limitStep((this._step - 1)));
        }

        function hasNextStep():Bool
        {
            return !(this._step == this.limitStep((this._step + 1)));
        }

        function limitStep(k:Int):Int
        {
            return Std.int(Math.max(1, Math.min(k, VIEW_CONFIRM)));
        }

        function getBaseDropMenu():IDropMenuWindow
        {
            return cast(this._window.findChildByName("base_dropmenu"), IDropMenuWindow);
        }

        function prepareRoomSelection()
        {
            var _local_5:RoomEntryData = null;
            var k= this.getBaseDropMenu();
            var _local_2= new Array<ASAny>();
            var _local_3 = 0;
            _local_2.push(this._manager.localization.getLocalization("group.edit.base.select.room", "group.edit.base.select.room"));
            var _local_4 = 0;
            while (_local_4 < this._data.ownedRooms.length)
            {
                _local_5 = this._data.ownedRooms[_local_4];
                _local_2.push(_local_5.roomName);
                if (_local_5.roomId == this._data.baseRoomId)
                {
                    _local_3 = (_local_4 + 1);
                }
                _local_4++;
            }
            k.populate(_local_2);
            if (_local_2.length > 0)
            {
                k.selection = _local_3;
            }
        }

        function resolveBaseRoom():RoomEntryData
        {
            var k= cast(this._window.findChildByName("base_dropmenu"), IDropMenuWindow);
            var _local_2= (k.selection - 1);
            if ((((_local_2 >= 0) && (_local_2 < this._data.ownedRooms.length)) && (!(this._data.ownedRooms[_local_2] == null))))
            {
                return cast(this._data.ownedRooms[_local_2], RoomEntryData);
            }
            return null;
        }

        function onCloseWindow(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if (this._data.exists)
            {
                if (!this.validateView())
                {
                    return;
                }
                this.saveView();
            }
            this.close();
        }

        public function close()
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        public function onPrimaryColorSelected(k:ColorGridCtrl)
        {
            var _local_3:GuildColorData = null;
            var _local_2= this._window.findChildByName("guild_color_primary_color_top");
            if (((((!(_local_2 == null)) && (!(this._manager.guildEditorData == null))) && (k._Str_4246 >= 0)) && (k._Str_4246 <= this._manager.guildEditorData._Str_17665.length)))
            {
                _local_3 = this._manager.guildEditorData._Str_17665[k._Str_4246];
                _local_2.color = _local_3.color;
            }
        }

        public function onSecondaryColorSelected(k:ColorGridCtrl)
        {
            var _local_3:GuildColorData = null;
            var _local_2= this._window.findChildByName("guild_color_secondary_color_top");
            if ((((!(this._manager.guildEditorData == null)) && (k._Str_4246 >= 0)) && (k._Str_4246 <= this._manager.guildEditorData._Str_16298.length)))
            {
                _local_3 = this._manager.guildEditorData._Str_16298[k._Str_4246];
                _local_2.color = _local_3.color;
            }
        }

        public var data(get,never):IGuildData;
public function  get_data():IGuildData
        {
            return this._data;
        }

        function refreshBadgeImage()
        {
            var k= this._window.findChildByName("step_1_badge");
            var _local_2= Std.downcast(cast(this._window.findChildByName("group_logo"), IWidgetWindow).widget , IBadgeImageWidget);
            if (((_local_2 == null) || (k == null)))
            {
                return;
            }
            if (!this._data.exists)
            {
                k.visible = false;
                k.invalidate();
            }
            else
            {
                _local_2.badgeId = this._data.badgeCode;
                _local_2.groupId = this._data.groupId;
                k.visible = true;
                k.invalidate();
            }
        }

        function onWindowUnActivated(k:WindowEvent)
        {
            if (((((!(this._data == null)) && this._data.exists) && (!(this._window == null))) && this._window.visible))
            {
                this.saveView();
            }
        }
    }

