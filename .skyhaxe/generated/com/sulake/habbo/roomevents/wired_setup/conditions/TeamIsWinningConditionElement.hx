package com.sulake.habbo.roomevents.wired_setup.conditions
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class TeamIsWinningConditionElement extends DefaultElement
    {
        var _team:RadioGroupPreset;
        var _placement:RadioGroupPreset;

        override public function  get_code():Int
        {
            return ConditionCodes.TEAM_IS_WINNING;
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._team = _arg_1.createRadioGroup([
                new RadioButtonParam(0, l("team.triggerer"), null, null, true),
                new RadioButtonParam(1, l("team.1")),
                new RadioButtonParam(2, l("team.2")),
                new RadioButtonParam(3, l("team.3")),
                new RadioButtonParam(4, l("team.4"))
            ], null, 2);
            this._placement = _arg_1.createRadioGroup([
                new RadioButtonParam(0, l("placement.1")),
                new RadioButtonParam(1, l("placement.2")),
                new RadioButtonParam(2, l("placement.3")),
                new RadioButtonParam(3, l("placement.4"))
            ], null, 4);
            _arg_3.addElements([_arg_1.createSection(l("team"), this._team), _arg_1.createSection(l("placement_selection"), this._placement)]);
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._team.selected, this._placement.selected];
        }

        override public function onEditStart(_arg_1:Triggerable)
        {
            this._team.selected = ASCompat.toInt((_arg_1.intData.length > 0) ? ASCompat.toInt(_arg_1.intData[0] ): 0);
            this._placement.selected = ASCompat.toInt((_arg_1.intData.length > 1) ? ASCompat.toInt(_arg_1.intData[1] ): 0);
        }

	public function new() { super(); }
    }

