package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValueCountOrUnlimited;
    import com.sulake.habbo.roomevents.wired_setup.common.slider_converter.SliderValueEcho;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.SliderSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class ScoreActionElement extends DefaultElement
    {
        var _code:Int = 0;
        var _includeTeam:Bool = false;
        var _score:SliderSection;
        var _times:SliderSection;
        var _operation:RadioGroupPreset;
        var _team:RadioGroupPreset;

        public function new(_arg_1:Int, _arg_2:Bool = false)
        {
            super();
            this._code = _arg_1;
            this._includeTeam = _arg_2;
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
            this._score = _arg_1.createSliderSection("wiredfurni.params.setpoints2", "", new SliderValueEcho(), 1, 1000, 1);
            this._times = _arg_1.createSliderSection("wiredfurni.params.settimesingame", "times", new SliderValueCountOrUnlimited(11), 1, 11, 1, false);
            this._operation = _arg_1.createRadioGroup([new RadioButtonParam(0, l("points_operation.0")), new RadioButtonParam(1, l("points_operation.1"))]);
            _arg_3.addElements([this._score, this._times, _arg_1.createSection(l("points_operation"), this._operation)]);
            if (this._includeTeam)
            {
                this._team = _arg_1.createRadioGroup([new RadioButtonParam(1, l("team.1")), new RadioButtonParam(2, l("team.2")), new RadioButtonParam(3, l("team.3")), new RadioButtonParam(4, l("team.4"))], null, 2);
                _arg_3.addElements([_arg_1.createSection(l("team"), this._team)]);
            }
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            var _local_2= this._score.value;
            if (this._operation.selected == 1)
            {
                _local_2 = -_local_2;
            }
            var _local_1:Array<ASAny> = [_local_2, (this._times.value == 11) ? 0 : this._times.value];
            if (this._includeTeam)
            {
                _local_1.push(this._team.selected);
            }
            return _local_1;
        }

        override public function onEditStart(_arg_1:Triggerable)
        {
            var _local_1= ASCompat.toInt((_arg_1.intData.length > 0) ? ASCompat.toInt(_arg_1.intData[0] ): 1);
            this._operation.selected = (_local_1 < 0) ? 1 : 0;
            this._score.value = Std.int(Math.abs(_local_1));
            this._times.value = ASCompat.toInt(((_arg_1.intData.length > 1) && (_arg_1.intData[1] == 0)) ? 11 : ASCompat.toInt((_arg_1.intData.length > 1) ? ASCompat.toInt(_arg_1.intData[1] ): 1));
            if (this._includeTeam)
            {
                this._team.selected = ASCompat.toInt((_arg_1.intData.length > 2) ? ASCompat.toInt(_arg_1.intData[2] ): 1);
            }
        }
    }

