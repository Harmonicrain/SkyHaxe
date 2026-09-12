package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValueEcho;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextAreaParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextAreaPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

     class MuteUserElement extends DefaultElement
    {
        var _message:TextAreaPreset;
        var _minutes:SliderSection;

        public function new()
        {
            super();
        }

        override public function  get_code():Int
        {
            return ActionTypeCodes.MUTE_USER;
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._minutes = _arg_1.createSliderSection("wiredfurni.params.length.minutes", "minutes", new SliderValueEcho(), 0, 10, 1);
            this._message = _arg_1.createTextArea(new TextAreaParam(40, -1, 4, -1, 100, "", null, null, true, true));
            _arg_3.addElements([this._minutes, _arg_1.createSection(l("message"), this._message)]);
        }

        override public function readStringParamFromForm():String
        {
            return this._message.text;
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._minutes.value];
        }

        override public function onEditStart(_arg_1:Triggerable)
        {
            this._message.text = _arg_1.stringData;
            this._minutes.value = ASCompat.toInt((_arg_1.intData.length > 0) ? ASCompat.toInt(_arg_1.intData[0] ): 1);
        }

        override public function validate():String
        {
            if (this._message.text.length > 100)
            {
                return loc("wiredfurni.chatmsgtoolong");
            }
            return null;
        }
    }

