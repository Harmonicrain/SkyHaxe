package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValueEcho;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

     class MoveFurniToElement extends DefaultElement
    {
        var _direction:RadioGroupPreset;
        var _tiles:SliderSection;

        public function new()
        {
            super();
        }

        override public function  get_code():Int
        {
            return ActionTypeCodes.MOVE_FURNI_TO;
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
            this._tiles = _arg_1.createSliderSection("wiredfurni.params.emptytiles", "tiles", new SliderValueEcho(), 1, 5, 1);
            this._direction = _arg_1.createRadioGroup([this.iconButton(0, "move_0"), this.iconButton(2, "move_2"), this.iconButton(4, "move_4"), this.iconButton(6, "move_6")], null, 4);
            _arg_3.addElements([this._tiles, _arg_1.createSection(l("placetodirection"), this._direction)]);
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._direction.selected, this._tiles.value];
        }

        override public function onEditStart(_arg_1:Triggerable)
        {
            this._direction.selected = ASCompat.toInt((_arg_1.intData.length > 0) ? ASCompat.toInt(_arg_1.intData[0] ): 0);
            this._tiles.value = ASCompat.toInt((_arg_1.intData.length > 1) ? ASCompat.toInt(_arg_1.intData[1] ): 1);
        }

        function iconButton(_arg_1:Int, _arg_2:String):RadioButtonParam
        {
            var _local_3= new RadioButtonParam(_arg_1, "");
            _local_3.iconAssetName = _arg_2;
            return _local_3;
        }
    }

