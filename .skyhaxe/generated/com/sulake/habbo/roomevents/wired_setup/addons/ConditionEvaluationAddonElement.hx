package com.sulake.habbo.roomevents.wired_setup.addons
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

    /** July addon 0: choose how the wired conditions are evaluated. */
     class ConditionEvaluationAddonElement extends DefaultElement
    {
        static inline final COMPARISON_MODE_START= 4;
        static inline final COMPARISON_COUNT= 3;

        var _comparisonValues:Vector<NumberInputPreset>;
        var _mode:RadioGroupPreset;

        override public function  get_code():Int { return AddonCodes.CONDITION_EVALUATION; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int { return WiredCapabilityCodes.ADDONS; }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
var comparison = 0;            var comparison = 0;
            this._comparisonValues = new Vector<NumberInputPreset>();
            for (_tmp_ in 0...COMPARISON_COUNT)
            {
comparison= _tmp_;
                this._comparisonValues.push(manager.createNumberInput(
                    new NumberInputParam(0, 0, 1000, 35, 0, false, false)));
            }
            this._mode = manager.createRadioGroup([
                new RadioButtonParam(0, this.l("eval_mode.0")),
                new RadioButtonParam(1, this.l("eval_mode.1")),
                new RadioButtonParam(2, this.l("eval_mode.2")),
                new RadioButtonParam(3, this.l("eval_mode.3")),
                new RadioButtonParam(4, this.l("eval_mode.cmp.0"), this._comparisonValues[0]),
                new RadioButtonParam(5, this.l("eval_mode.cmp.1"), this._comparisonValues[1]),
                new RadioButtonParam(6, this.l("eval_mode.cmp.2"), this._comparisonValues[2])
            ]);
            builder.addElements([manager.createUsageInfoSection(this.l("cond_eval.note")),
                manager.createSection(this.l("eval_mode"), this._mode)]);
        }

        override public function onEditStart(definition:Triggerable)
        {
var index = 0, value = 0;            var index = 0;
            for (_tmp_ in 0...COMPARISON_COUNT)
            {
index= _tmp_;
                this._comparisonValues[index].value = 0;
            }
            var mode= definition.intData.length > 0 ? ASCompat.toInt(definition.intData[0]) : 0;
            if (mode == -1)
            {
                index = definition.intData.length > 1 ? ASCompat.toInt(definition.intData[1]) : 0;
value= definition.intData.length > 2 ? ASCompat.toInt(definition.intData[2]) : 0;
                mode = COMPARISON_MODE_START + index;
                if (index >= 0 && index < this._comparisonValues.length)
                {
                    this._comparisonValues[index].value = value;
                }
            }
            this._mode.selected = mode;
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            var mode= this._mode.selected;
            var index= 0;
            var value= 0;
            if (mode >= COMPARISON_MODE_START)
            {
                index = mode - COMPARISON_MODE_START;
                value = this._comparisonValues[index].value;
                mode = -1;
            }
            return [mode, index, value];
        }

	public function new() { super(); }
    }

