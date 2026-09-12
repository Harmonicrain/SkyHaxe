package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedNumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

     class MoveAsGroupActionElement extends DefaultElement
    {
        var _x:NamedNumberInputPreset;
        var _y:NamedNumberInputPreset;
        var _useUserSource:Bool = true;

        override public function  get_code():Int { return ActionTypeCodes.MOVE_AS_GROUP; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiresFurniSelection():Bool { return true; }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            _arg_3.addElements([_arg_1.createUsageInfoSection("${wiredfurni.params.move_as_group.usage_info}")]);
            this._x = _arg_1.createNamedNumberInput(new NumberInputParam(0, -64, 64), "${wiredfurni.params.place_furni.offsets.x}");
            this._y = _arg_1.createNamedNumberInput(new NumberInputParam(0, -64, 64), "${wiredfurni.params.place_furni.offsets.y}");
            _arg_3.addElements([_arg_1.createSection("${wiredfurni.params.place_furni.offsets}", _arg_1.createSimpleListView(true, [this._x, this._y]))]);
        }

        override public function readIntParamsFromForm():Array<ASAny> { return [this._useUserSource ? 1 : 0, this._x.value, this._y.value]; }

        override public function onEditStart(_arg_1:Triggerable)
        {
            this._useUserSource = (_arg_1.intData.length > 0) ? (_arg_1.intData[0] == 1) : true;
            this._x.value = ASCompat.toInt((_arg_1.intData.length > 1) ? ASCompat.toInt(_arg_1.intData[1] ): 0);
            this._y.value = ASCompat.toInt((_arg_1.intData.length > 2) ? ASCompat.toInt(_arg_1.intData[2] ): 0);
        }

        override public function mergedSelections():Array<ASAny>
        {
            return [([1, 0] : Array<Dynamic>)];
        }

        override public function setMergedType(_arg_1:Int, _arg_2:Int)
        {
            this._useUserSource = _arg_2 == WiredInputSourcePicker.USER_SOURCE;
        }

        override public function getMergedType(_arg_1:Int):Int
        {
            return this._useUserSource ? WiredInputSourcePicker.USER_SOURCE : WiredInputSourcePicker.FURNI_SOURCE;
        }

        override public function furniSelectionTitle(_arg_1:Int):String
        {
            return "wiredfurni.params.sources.furni.title.mv.0";
        }

        override public function mergedSelectionTitle(_arg_1:Int):String
        {
            return "wiredfurni.params.sources.merged.title.target_location";
        }

        override public function advancedAlwaysVisible():Bool
        {
            return true;
        }

        override public function  get_forceHidePickFurniInstructions():Bool
        {
            return true;
        }

	public function new() { super(); }
    }

