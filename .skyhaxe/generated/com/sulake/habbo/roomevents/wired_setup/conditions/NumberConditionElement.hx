package com.sulake.habbo.roomevents.wired_setup.conditions
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.NumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class NumberConditionElement extends DefaultElement
    {
        var _code:Int = 0;
        var _negativeCode:Int = 0;
        var _section:String;
        var _input:NumberInputPreset;

        public function new(_arg_1:Int, _arg_2:Int, _arg_3:String)
        {
            super();
            this._code = _arg_1;
            this._negativeCode = _arg_2;
            this._section = _arg_3;
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

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._input = _arg_1.createNumberInput(new NumberInputParam(0, 0, 99999));
            _arg_3.addElements([_arg_1.createSection(this._section, this._input)]);
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._input.value];
        }

        override public function onEditStart(_arg_1:Triggerable)
        {
            this._input.value = ASCompat.toInt((_arg_1.intData.length > 0) ? ASCompat.toInt(_arg_1.intData[0] ): 0);
        }
    }

