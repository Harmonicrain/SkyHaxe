package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextAreaParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextAreaPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class TextActionElement extends DefaultElement
    {
        var _code:Int = 0;
        var _section:String;
        var _input:TextAreaPreset;

        public function new(_arg_1:Int, _arg_2:String)
        {
            super();
            this._code = _arg_1;
            this._section = _arg_2;
        }

        override public function  get_code():Int
        {
            return this._code;
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._input = _arg_1.createTextArea(new TextAreaParam(40, -1, 4, -1, 100, "", null, null, true, true));
            _arg_3.addElements([_arg_1.createSection(this._section, this._input)]);
        }

        override public function readStringParamFromForm():String
        {
            return this._input.text;
        }

        override public function onEditStart(_arg_1:Triggerable)
        {
            this._input.text = _arg_1.stringData;
        }

        override public function validate():String
        {
            if (this._input.text.length > 100)
            {
                return loc("wiredfurni.chatmsgtoolong");
            }
            return null;
        }
    }

