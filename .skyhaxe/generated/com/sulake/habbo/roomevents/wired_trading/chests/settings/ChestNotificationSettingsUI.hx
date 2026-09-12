package com.sulake.habbo.roomevents.wired_trading.chests.settings
;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests.ChestSettingsResultMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.SaveChestNotificationsMessageComposer;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.ListScrollParams;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_trading.AbstractUbuntuWiredUI;
    import com.sulake.habbo.roomevents.wired_trading.chests.ChestType;
    import com.sulake.habbo.roomevents.wired_trading.chests.WiredChestController;
    import flash.system.Capabilities;

     class ChestNotificationSettingsUI extends AbstractUbuntuWiredUI
    {
        var _controller:WiredChestController;
        var _generic:CheckboxGroupPreset;
        var _wiredSection:SectionPreset;
        var _wired:CheckboxGroupPreset;
        var _mode:DropdownPreset;
        var _resultEvent:ChestSettingsResultMessageEvent;
        var _chestId:Int = -1;

        public function new(controller:WiredChestController,
            presets:PresetManager)
        {
            super(controller.roomEvents, presets);
            this._controller = controller;
            this._resultEvent = new ChestSettingsResultMessageEvent(this.onUpdateSuccess);
            controller.addMessageEvent(this._resultEvent);
            var style= presets.wiredStyle;
            var info= presets.createUsageInfoSection(
                "${wiredchests.notification_settings.notification_info.desc}", true,
                "${wiredchests.notification_settings.notification_info}");
            this._generic = presets.createCheckboxGroup([
                new CheckboxOptionParam(
                    "${wiredchests.notification_settings.enable_notifications.generic.0}", 0),
                new CheckboxOptionParam(
                    "${wiredchests.notification_settings.enable_notifications.generic.1}", 1)]);
            this._wired = presets.createCheckboxGroup([
                new CheckboxOptionParam(
                    "${wiredchests.notification_settings.enable_notifications.wired.0}", 0),
                new CheckboxOptionParam(
                    "${wiredchests.notification_settings.enable_notifications.wired.1}", 1),
                new CheckboxOptionParam(
                    "${wiredchests.notification_settings.enable_notifications.wired.2}", 2)]);
            var genericSection= presets.createSection(
                "${wiredchests.notification_settings.enable_notifications.generic}",
                this._generic);
            genericSection.splitterVisible = false;
            this._wiredSection = presets.createSection(
                "${wiredchests.notification_settings.enable_notifications.wired}",
                this._wired);
            var notificationList= presets.createSimpleListView(
                true, [genericSection, this._wiredSection]);
            notificationList.spacing = style.sectionSpacing;
            var notificationSection= presets.createBorderSection(
                "${wiredchests.notification_settings.enable_notifications}",
                notificationList);
            var modes=
                new Vector<ExpandableDropdownOption>();
            modes.push(new ExpandableDropdownOption(0,
                "${wiredchests.notification_settings.notification_mode.when.0}"));
            modes.push(new ExpandableDropdownOption(1,
                "${wiredchests.notification_settings.notification_mode.when.1}"));
            this._mode = presets.createDropdown(new DropdownParam(
                "${wiredchests.notification_settings.notification_mode.when}", modes));
            var modeSection= presets.createSection(
                "${wiredchests.notification_settings.notification_mode.when}", this._mode);
            modeSection.splitterVisible = false;
            var modeBorder= presets.createBorderSection(
                "${wiredchests.notification_settings.notification_mode}", modeSection);
            var scroll= new ListScrollParams(false, 320,
                Std.int(Capabilities.screenResolutionY / 2.4), true);
            framePreset = presets.createFramePreset([info, notificationSection,
                modeBorder, footerPreset], onCloseClicked, null, -1, false, false, scroll);
            framePreset.resizeToWidth(350);
        }
        function onUpdateSuccess(event:ChestSettingsResultMessageEvent)
        {
            if (event.getParser().chestId == this._chestId
                && event.getParser().isNotificationPreferences)
            {
                this.hideFrame();
            }
        }
        public function onEdit(chestId:Int, chestType:Int, data:Map)
        {
            this._chestId = chestId;
            var typeName= localization.getLocalization("wiredchests."
                + (chestType == ChestType.FURNI ? "furni" : "coin") + "_chest");
            framePreset.title = localization.getLocalizationWithParams(
                "wiredchests.notification_settings.title", "", ["chest_type", typeName]);
            this._generic.get(0).selected =
                data.getValue("notification_chest_full") == "1";
            this._generic.get(1).selected =
                data.getValue("notification_donation") == "1";
            this._wired.get(0).selected =
                data.getValue("notification_someone_withdraws") == "1";
            this._wired.get(1).selected =
                data.getValue("notification_chest_empty") == "1";
            this._wired.get(2).selected =
                data.getValue("notification_wired_transaction") == "1";
            this._mode.selectedId = ASCompat.toInt(data.getValue("notify_mode"));
            this._wiredSection.disabled = data.getValue("is_wired_enabled") != "1";
            this.showFrame();
        }
        override public function onSaveClicked()
        {
            this._controller.send(new SaveChestNotificationsMessageComposer(
                this._chestId, this._mode.selectedId,
                this._generic.get(0).selected, this._generic.get(1).selected,
                this._wired.get(0).selected, this._wired.get(1).selected,
                this._wired.get(2).selected));
        }
        override public function dispose()
        {
            if (disposed) { return; }
            this._controller.removeMessageEvent(this._resultEvent);
            this._resultEvent.dispose();
            this._resultEvent = null;
            this._controller = null;
            super.dispose();
        }
    }

