package com.sulake.habbo.roomevents.wired_setup.actiontypes.chests
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July action 48: cancel a selected contract or any active transaction. */
     class CancelTransactionActionElement extends DefaultElement
    {
        var _mode:RadioGroupPreset;

        override public function  get_code():Int { return ActionTypeCodes.CANCEL_TRANSACTION; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.CHESTS | WiredCapabilityCodes.CHEST_WIRED |
                WiredCapabilityCodes.CONTRACTS;
        }
        override public function readIntParamsFromForm():Array<ASAny> { return [this._mode.selected]; }
        override public function onEditStart(definition:Triggerable)
        {
            this._mode.selected = definition.intData.length > 0 ? ASCompat.toInt(definition.intData[0]) : 0;
        }
        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._mode = manager.createRadioGroup([
                new RadioButtonParam(0, "${wiredfurni.params.cancel_transaction.match_criteria.0}"),
                new RadioButtonParam(1, "${wiredfurni.params.cancel_transaction.match_criteria.1}")
            ], this.onModeChange);
            builder.addElements(
                [manager.createUsageInfoSection("${wiredfurni.params.cancel_transaction.usage_info}"),
                manager.createSection("${wiredfurni.params.cancel_transaction.match_criteria}",
                    this._mode)]);
        }
        function onModeChange(value:Int)
        {
            this.roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.FURNI_SOURCE, 0);
        }
        override public function isInputSourceDisabled(index:Int, sourceType:Int):Bool
        {
            return sourceType == WiredInputSourcePicker.FURNI_SOURCE && index == 0 &&
                this._mode.selected == 1;
        }

	public function new() { super(); }
    }

