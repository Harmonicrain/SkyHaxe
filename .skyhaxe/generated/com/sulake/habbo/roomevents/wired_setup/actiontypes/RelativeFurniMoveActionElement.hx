package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedNumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

     class RelativeFurniMoveActionElement extends DefaultElement
    {
        var _x:NamedNumberInputPreset;
        var _y:NamedNumberInputPreset;

        override public function  get_code():Int { return ActionTypeCodes.RELATIVE_FURNI_MOVE; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiresFurniSelection():Bool { return true; }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._x = _arg_1.createNamedNumberInput(new NumberInputParam(0, -20, 20), l("movement.horizontal.distance"));
            this._y = _arg_1.createNamedNumberInput(new NumberInputParam(0, -20, 20), l("movement.vertical.distance"));
            _arg_3.addElements([_arg_1.createSection(l("movement.relative"), _arg_1.createSimpleListView(true, [this._x, this._y]))]);
        }

        override public function readIntParamsFromForm():Array<ASAny> { return [this._x.value, this._y.value]; }
        override public function onEditStart(_arg_1:Triggerable)
        {
            this._x.value = ASCompat.toInt((_arg_1.intData.length > 0) ? ASCompat.toInt(_arg_1.intData[0] ): 0);
            this._y.value = ASCompat.toInt((_arg_1.intData.length > 1) ? ASCompat.toInt(_arg_1.intData[1] ): 0);
        }

	public function new() { super(); }
    }

