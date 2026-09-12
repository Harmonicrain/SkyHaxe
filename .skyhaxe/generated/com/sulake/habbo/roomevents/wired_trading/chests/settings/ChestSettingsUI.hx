package com.sulake.habbo.roomevents.wired_trading.chests.settings
;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests.ChestSettingsResultMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.chests.SaveChestSettingsMessageComposer;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.ListScrollParams;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextAreaParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.ContainerButtonPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.StaticBitmapAssetWrapperPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextAreaPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_trading.AbstractUbuntuWiredUI;
    import com.sulake.habbo.roomevents.wired_trading.chests.ChestType;
    import com.sulake.habbo.roomevents.wired_trading.chests.WiredChestController;
    import flash.system.Capabilities;

     class ChestSettingsUI extends AbstractUbuntuWiredUI
    {
        var _controller:WiredChestController;
        var _access:CheckboxGroupPreset;
        var _name:TextInputPreset;
        var _description:TextAreaPreset;
        var _state:DropdownPreset;
        var _previewSection:SectionPreset;
        var _preview:DropdownPreset;
        var _previewAmountSection:SectionPreset;
        var _previewAmount:DropdownPreset;
        var _wiredUpgrade:ContainerButtonPreset;
        var _wiredEnabledIcon:StaticBitmapAssetWrapperPreset;
        var _wiredUpgradeConfirmation:
            WiredChestWiredUpdateConfirmationView;
        var _resultEvent:ChestSettingsResultMessageEvent;
        var _chestType:Int = 0;
        var _chestId:Int = -1;
        var _chestItemType:Int = 0;
        var _isStarter:Bool = false;

        public function new(controller:WiredChestController, presets:PresetManager)
        {
var i = 0;            super(controller.roomEvents, presets);
            this._controller = controller;
            this._resultEvent = new ChestSettingsResultMessageEvent(this.onUpdateSuccess);
            controller.addMessageEvent(this._resultEvent);
            var style= presets.wiredStyle;
            this._access = presets.createCheckboxGroup([
                new CheckboxOptionParam("${wiredchests.settings.access.open}"),
                new CheckboxOptionParam("${wiredchests.settings.access.donate}")]);
            var accessSection= presets.createBorderSection(
                "${wiredchests.settings.access}", this._access);
            this._name = presets.createTextInput(new TextInputParam("", 30));
            this._description = presets.createTextArea(
                new TextAreaParam(64, -1, 4, -1, 200, "", null, null, true, true));
            var nameSection= presets.createSection(
                "${wiredchests.settings.info.name}", this._name);
            nameSection.splitterVisible = false;
            var descriptionSection= presets.createSection(
                "${wiredchests.settings.info.desc}", this._description);
            var infoList= presets.createSimpleListView(
                true, [nameSection, descriptionSection]);
            infoList.spacing = style.sectionSpacing;
            var infoSection= presets.createBorderSection(
                "${wiredchests.settings.info}", infoList);
            var states= new Vector<ExpandableDropdownOption>();
            var i = 0;
            for (_tmp_ in 0...4)
            {
i= _tmp_;
                states.push(new ExpandableDropdownOption(i,
                    "${wiredchests.settings.appearance.state." + Std.string(i) + "}"));
            }
            var previews=
                new Vector<ExpandableDropdownOption>();
            for (_tmp_ in 0...8)
            {
i= _tmp_;
                previews.push(new ExpandableDropdownOption(i,
                    "${wiredchests.settings.appearance.preview." + Std.string(i) + "}"));
            }
            var amounts=
                new Vector<ExpandableDropdownOption>();
            for (_tmp_ in 1...5)
            {
i = _tmp_;
                amounts.push(new ExpandableDropdownOption(i, Std.string(i)));
            }
            this._state = presets.createDropdown(new DropdownParam(
                "${wiredchests.settings.appearance.state}", states));
            var stateSection= presets.createSection(
                "${wiredchests.settings.appearance.state}", this._state);
            stateSection.splitterVisible = false;
            this._preview = presets.createDropdown(new DropdownParam(
                "${wiredchests.settings.appearance.preview}", previews,
                this.onChangePreview));
            this._previewSection = presets.createSection(
                "${wiredchests.settings.appearance.preview}",
                presets.createSimpleListView(true, [this._preview,
                    presets.createText("${wiredchests.settings.appearance.preview.note}")
                        .halfBlend()]));
            this._previewAmount = presets.createDropdown(new DropdownParam(
                "${wiredchests.settings.appearance.preview_amount}", amounts));
            this._previewAmountSection = presets.createSection(
                "${wiredchests.settings.appearance.preview_amount}", this._previewAmount);
            var appearanceList= presets.createSimpleListView(
                true, [stateSection, this._previewSection, this._previewAmountSection]);
            appearanceList.spacing = style.sectionSpacing;
            var appearanceSection= presets.createBorderSection(
                "${wiredchests.settings.appearance}", appearanceList);
            var upgradeContent= presets.createSimpleListView(false, [
                presets.createBitmapWrapperPreset("${image.library.url}catalogue/icon_80.png"),
                presets.createText("${wiredchests.settings.wired.upgrade}", new TextParam(0))
            ], true);
            this._wiredUpgrade = presets.createContainerButtonPreset(
                upgradeContent.alignCenter(), this.onClickUpgrade, false);
            this._wiredEnabledIcon = presets.createBitmapWrapperPreset("icon_checkmark_small");
            var wiredList= presets.createSimpleListView(false,
                [this._wiredUpgrade, this._wiredEnabledIcon], true);
            var wiredSection= presets.createBorderSection(
                "${wiredchests.settings.wired}", wiredList);
            var scroll= new ListScrollParams(false, 420,
                Std.int(Capabilities.screenResolutionY / 2.4), true);
            framePreset = presets.createFramePreset([accessSection, infoSection,
                appearanceSection, wiredSection, footerPreset], onCloseClicked,
                null, -1, false, false, scroll);
            framePreset.resizeToWidth(300);
        }
        function onUpdateSuccess(event:ChestSettingsResultMessageEvent)
        {
            if (event.getParser().chestId == this._chestId
                && !event.getParser().isNotificationPreferences)
            {
                this.hideFrame();
            }
        }
        override function hideFrame()
        {
            super.hideFrame();
            if (this._wiredUpgradeConfirmation != null)
            {
                this._wiredUpgradeConfirmation.hide();
            }
        }
        function onClickUpgrade()
        {
            if (this._wiredUpgrade.disabled) { return; }
            if (this._wiredUpgradeConfirmation == null)
            {
                this._wiredUpgradeConfirmation =
                    new WiredChestWiredUpdateConfirmationView(this);
            }
            this._wiredUpgradeConfirmation.initialize(
                this._chestId, this._chestType,
                this._chestItemType, this._isStarter);
            this._wiredUpgradeConfirmation.show();
        }
        @:allow(com.sulake.habbo.roomevents.wired_trading.chests.settings) function confirmUpgrade()
        {
            this._wiredUpgrade.disabled = true;
            this._wiredEnabledIcon.visible = true;
            this.onSaveClicked();
        }
        function onChangePreview(option:ExpandableDropdownOption)
        {
            this._previewAmountSection.disabled = option.id == 0;
        }
        public function onEdit(chestId:Int, chestType:Int, chestItemType:Int,
            isStarter:Bool, data:Map)
        {
            this._chestId = chestId;
            this._chestType = chestType;
            this._chestItemType = chestItemType;
            this._isStarter = isStarter;
            this._previewSection.visible = chestType == ChestType.FURNI;
            this._previewAmountSection.visible = chestType == ChestType.FURNI;
            var typeName= localization.getLocalization("wiredchests."
                + (chestType == ChestType.FURNI ? "furni" : "coin") + "_chest");
            framePreset.title = localization.getLocalizationWithParams(
                "wiredchests.settings.title", "", ["chest_type", typeName]);
            this._access.get(0).selected = data.getValue("everyone_can_open") == "1";
            this._access.get(1).selected = data.getValue("everyone_can_donate") == "1";
            this._name.text = data.getValue("chest_name");
            this._description.text = data.getValue("chest_desc");
            this._state.selectedId = ASCompat.toInt(data.getValue("state_control_mode"));
            var wired= data.getValue("is_wired_enabled") == "1";
            this._wiredUpgrade.disabled = wired;
            this._wiredEnabledIcon.visible = wired;
            if (chestType == ChestType.FURNI)
            {
                this._preview.selectedId = ASCompat.toInt(data.getValue("preview_mode"));
                this._previewAmount.selectedId = ASCompat.toInt(data.getValue("preview_amount"));
                this._previewAmountSection.disabled = this._preview.selectedId == 0;
            }
            this.showFrame();
        }
        override public function onSaveClicked()
        {
            this._controller.send(new SaveChestSettingsMessageComposer(
                this._chestId, this._name.text, this._description.text,
                this._access.get(0).selected, this._access.get(1).selected,
                this._state.selectedId, this._preview.selectedId,
                this._previewAmount.selectedId, this._wiredUpgrade.disabled));
        }
        override public function dispose()
        {
            if (disposed) { return; }
            if (this._wiredUpgradeConfirmation != null)
            {
                this._wiredUpgradeConfirmation.dispose();
                this._wiredUpgradeConfirmation = null;
            }
            this._controller.removeMessageEvent(this._resultEvent);
            this._resultEvent.dispose();
            this._resultEvent = null;
            this._controller = null;
            super.dispose();
        }

        public var chestController(get,never):WiredChestController;
public function  get_chestController():WiredChestController
        {
            return this._controller;
        }
    }

