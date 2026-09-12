package com.sulake.habbo.roomevents.wired_setup.selectors
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.NumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July AIR selector 19: [union/intersection, all/random amount]. */
     class RemoteSelectorElement extends DefaultElement
    {
        var _aggregation:RadioGroupPreset;
        var _randomMode:RadioGroupPreset;
        var _randomAmount:NumberInputPreset;

        override public function  get_code():Int
        {
            return SelectorCodes.REMOTE_SELECTOR;
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.REMOTE_SELECTOR;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._aggregation = _arg_1.createRadioGroup([
                new RadioButtonParam(0, l("remote_selection.type.0")),
                new RadioButtonParam(1, l("remote_selection.type.1"))
            ]);
            this._randomAmount = _arg_1.createNumberInput(new NumberInputParam(0, 0, ASCompat.MAX_INT, 40, 0, false));
            this._randomMode = _arg_1.createRadioGroup([
                new RadioButtonParam(0, l("remote_selection.filter.0")),
                new RadioButtonParam(1, l("remote_selection.filter.1"), this._randomAmount)
            ]);
            _arg_3.addElements(
                [_arg_1.createSection(l("remote_selection.type"), this._aggregation),
                _arg_1.createSection(l("remote_selection.filter"), this._randomMode)]);
        }

        override public function onEditStart(_arg_1:Triggerable)
        {
            var aggregation= (_arg_1.intData.length > 0 && ASCompat.toInt(_arg_1.intData[0]) == 1) ? 1 : 0;
            var randomAmount= Std.int((_arg_1.intData.length > 1) ? Std.int(Math.max(0, ASCompat.toInt(_arg_1.intData[1])) ): 0);
            this._aggregation.selected = aggregation;
            this._randomMode.selected = randomAmount > 0 ? 1 : 0;
            this._randomAmount.value = randomAmount;
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            var randomAmount= this._randomMode.selected == 1 ? this._randomAmount.value : 0;
            return [this._aggregation.selected, randomAmount];
        }

	public function new() { super(); }
    }

