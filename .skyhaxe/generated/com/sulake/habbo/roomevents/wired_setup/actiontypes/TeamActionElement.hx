package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class TeamActionElement extends DefaultElement
    {
        var _code:Int = 0;
        var _team:RadioGroupPreset;

        public function new(_arg_1:Int)
        {
            super();
            this._code = _arg_1;
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
            this._team = createTeamRadio(_arg_1);
            _arg_3.addElements([_arg_1.createSection(l("team"), this._team)]);
        }

        function createTeamRadio(_arg_1:PresetManager):RadioGroupPreset
        {
            return _arg_1.createRadioGroup([new RadioButtonParam(1, l("team.1")), new RadioButtonParam(2, l("team.2")), new RadioButtonParam(3, l("team.3")), new RadioButtonParam(4, l("team.4"))], null, 2);
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._team.selected];
        }

        override public function onEditStart(_arg_1:Triggerable)
        {
            this._team.selected = ASCompat.toInt((_arg_1.intData.length > 0) ? ASCompat.toInt(_arg_1.intData[0] ): 1);
        }
    }

