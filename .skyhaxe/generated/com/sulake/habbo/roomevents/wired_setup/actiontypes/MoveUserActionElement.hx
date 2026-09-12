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

     class MoveUserActionElement extends DefaultElement
    {
        var _move:RadioGroupPreset;
        var _rotate:RadioGroupPreset;

        override public function  get_code():Int { return ActionTypeCodes.MOVE_USER; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._move = _arg_1.createRadioGroup(this.directionOptions(l("movefurni.0")), null, 4);
            this._rotate = _arg_1.createRadioGroup(this.directionOptions(l("rotatefurni.0"), true), null, 4);
            _arg_3.addElements([_arg_1.createSection(l("moveuser"), this._move), _arg_1.createSection(l("rotateuser"), this._rotate)]);
        }

        override public function readIntParamsFromForm():Array<ASAny> { return [this._move.selected, this._rotate.selected]; }
        override public function onEditStart(_arg_1:Triggerable)
        {
            this._move.selected = ASCompat.toInt((_arg_1.intData.length > 0) ? ASCompat.toInt(_arg_1.intData[0] ): -1);
            this._rotate.selected = ASCompat.toInt((_arg_1.intData.length > 1) ? ASCompat.toInt(_arg_1.intData[1] ): -1);
        }

        function directionOptions(_arg_1:String, _arg_2:Bool = false):Array<ASAny>
        {
var _local_4 = 0;            var _local_3:Array<ASAny> = [new RadioButtonParam(-1, _arg_1, null, null, true)];
            for (_tmp_ in 0...8) { _local_4= _tmp_;
_local_3.push(this.iconButton(_local_4, "move_" + Std.string(_local_4))); }
            if (_arg_2) { _local_3.push(this.iconButton(9, "rotate_cw")); _local_3.push(this.iconButton(10, "rotate_ccw")); }
            return _local_3;
        }

        function iconButton(_arg_1:Int, _arg_2:String):RadioButtonParam
        {
            var _local_3= new RadioButtonParam(_arg_1, "");
            _local_3.iconAssetName = _arg_2;
            return _local_3;
        }

	public function new() { super(); }
    }

