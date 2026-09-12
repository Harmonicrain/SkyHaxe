package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

     class ToggleFurniStateElement extends DefaultElement
    {
        var _mode:RadioGroupPreset;

        override public function  get_code():Int
        {
            return ActionTypeCodes.TOGGLE_FURNI_STATE;
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
            this._mode = _arg_1.createRadioGroup([new RadioButtonParam(0, l("togglefurni.0")), new RadioButtonParam(1, l("togglefurni.1"))]);
            _arg_3.addElements([_arg_1.createSection(l("togglefurni"), this._mode)]);
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._mode.selected];
        }

        override public function onEditStart(_arg_1:Triggerable)
        {
            this._mode.selected = ASCompat.toInt((_arg_1.intData.length > 0) ? ASCompat.toInt(_arg_1.intData[0] ): 0);
        }

	public function new() { super(); }
    }

