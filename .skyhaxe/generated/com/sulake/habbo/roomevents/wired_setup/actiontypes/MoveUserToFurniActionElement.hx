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

     class MoveUserToFurniActionElement extends DefaultElement
    {
        var _walkMode:RadioGroupPreset;

        override public function  get_code():Int { return ActionTypeCodes.MOVE_USER_TO_FURNI; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiresFurniSelection():Bool { return true; }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._walkMode = _arg_1.createRadioGroup([new RadioButtonParam(0, l("user_move.walkmode.0")), new RadioButtonParam(1, l("user_move.walkmode.1")), new RadioButtonParam(2, l("user_move.walkmode.2"))]);
            _arg_3.addElements([_arg_1.createSection(l("user_move.walkmode"), this._walkMode)]);
        }

        override public function readIntParamsFromForm():Array<ASAny> { return [this._walkMode.selected]; }
        override public function onEditStart(_arg_1:Triggerable) { this._walkMode.selected = ASCompat.toInt((_arg_1.intData.length > 0) ? ASCompat.toInt(_arg_1.intData[0] ): 0); }
        override public function furniSelectionTitle(_arg_1:Int):String { return "wiredfurni.params.sources.furni.title.mv.1"; }
        override public function userSelectionTitle(_arg_1:Int):String { return "wiredfurni.params.sources.furni.title.mv_user2"; }
        override public function advancedAlwaysVisible():Bool { return true; }

	public function new() { super(); }
    }

