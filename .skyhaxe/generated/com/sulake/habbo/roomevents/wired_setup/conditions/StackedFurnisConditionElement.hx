package com.sulake.habbo.roomevents.wired_setup.conditions
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class StackedFurnisConditionElement extends DefaultElement
    {
        var _code:Int = 0;
        var _negativeCode:Int = 0;
        var _section:String;
        var _optionPrefix:String;
        var _eval:RadioGroupPreset;

        public function new(_arg_1:Int = 7, _arg_2:Int = -1, _arg_3:String = "requireall", _arg_4:String = "requireall")
        {
            super();
            this._code = _arg_1;
            this._negativeCode = _arg_2;
            this._section = _arg_3;
            this._optionPrefix = _arg_4;
        }

        override public function  get_code():Int
        {
            return this._code;
        }

        override public function  get_negativeCode():Int
        {
            return this._negativeCode;
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function  get_requiresFurniSelection():Bool
        {
            return true;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._eval = _arg_1.createRadioGroup([new RadioButtonParam(0, l(this._optionPrefix + ".0")), new RadioButtonParam(1, l(this._optionPrefix + ".1"))]);
            _arg_3.addElements([_arg_1.createSection(l(this._section), this._eval)]);
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._eval.selected];
        }

        override public function onEditStart(_arg_1:Triggerable)
        {
            this._eval.selected = ASCompat.toInt((_arg_1.intData.length > 0) ? ASCompat.toInt(_arg_1.intData[0] ): 0);
        }
    }

