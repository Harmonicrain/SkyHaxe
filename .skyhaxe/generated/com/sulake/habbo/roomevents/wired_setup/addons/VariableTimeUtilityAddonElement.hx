package com.sulake.habbo.roomevents.wired_setup.addons
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.applications.SubVariableParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.applications.SubVariableCreatorPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** Exact July add-on 1002 editor and payload. */
     class VariableTimeUtilityAddonElement extends DefaultElement
    {
        static inline final SOURCE_VALUE= 0;
        static inline final SOURCE_CREATION_TIME= 1;
        static inline final SOURCE_LAST_UPDATE_TIME= 2;

        var _mode:DropdownPreset;
        var _standard:SubVariableCreatorPreset;
        var _advanced:SubVariableCreatorPreset;

        override public function  get_code():Int { return AddonCodes.VARIABLE_TIME_UTIL; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.ADDONS | WiredCapabilityCodes.VARIABLES |
                WiredCapabilityCodes.VARIABLE_SYNC;
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._mode = manager.createDropdown(new DropdownParam(this.l("choose_type"),
                Vector.ofArray([
                    new ExpandableDropdownOption(SOURCE_VALUE, this.l("time_util.mode.0")),
                    new ExpandableDropdownOption(SOURCE_CREATION_TIME, this.l("time_util.mode.1")),
                    new ExpandableDropdownOption(SOURCE_LAST_UPDATE_TIME, this.l("time_util.mode.2"))
                ])));

            this._standard = manager.createSubVariableCreator(
                "wiredfurni.params.time_util.subvariable.", [
                    new SubVariableParam(1, "milliseconds_of_seconds"),
                    new SubVariableParam(2, "seconds_of_minute"),
                    new SubVariableParam(3, "minute_of_hour"),
                    new SubVariableParam(4, "hour_of_day"),
                    new SubVariableParam(5, "day_of_week"),
                    new SubVariableParam(6, "day_of_month"),
                    new SubVariableParam(7, "day_of_year"),
                    new SubVariableParam(8, "week_of_year"),
                    new SubVariableParam(9, "month_of_year"),
                    new SubVariableParam(10, "year")
                ]);
            this._advanced = manager.createSubVariableCreator(
                "wiredfurni.params.time_util.subvariable.", [
                    new SubVariableParam(20, "millisecond"),
                    new SubVariableParam(21, "second"),
                    new SubVariableParam(22, "minute"),
                    new SubVariableParam(23, "hour"),
                    new SubVariableParam(24, "day"),
                    new SubVariableParam(25, "week"),
                    new SubVariableParam(26, "month")
                ]);

            builder.addElements(
                [manager.createSection(this.l("choose_type"), this._mode),
                manager.createSection(this.loc("wiredfurni.params.create_subvariables"),
                    this._standard, SectionParam.EXPANDED_WITH_TOGGLE),
                manager.createSection(this.l("create_subvariables.advanced"),
                    manager.createSimpleListView(true, [
                        manager.createText(this.l("time_util.advanced_info")), this._advanced
                    ]), SectionParam.COLLAPSED)]);
        }

        override public function onEditStart(data:Triggerable)
        {
            var mask= data.intData.length > 0 ? ASCompat.toInt(data.intData[0]) : 0;
            var selectedMode= data.intData.length > 1 ? ASCompat.toInt(data.intData[1]) : SOURCE_VALUE;
            this._standard.mask = mask & 0xFFFF;
            this._advanced.mask = mask & ASCompat.toInt(0xFFFF0000);

            var variables= data.wiredContext != null &&
                data.wiredContext.rulesetVariables != null
                ? data.wiredContext.rulesetVariables.variables : [];
            var options= new Vector<ExpandableDropdownOption>();
            if (this.showValue(variables, selectedMode))
                options.push(new ExpandableDropdownOption(SOURCE_VALUE, this.l("time_util.mode.0")));
            if (this.showCreationTime(variables, selectedMode))
                options.push(new ExpandableDropdownOption(SOURCE_CREATION_TIME, this.l("time_util.mode.1")));
            if (this.showLastUpdateTime(variables, selectedMode))
                options.push(new ExpandableDropdownOption(SOURCE_LAST_UPDATE_TIME, this.l("time_util.mode.2")));
            this._mode.reinit(options, selectedMode);
        }

        function showValue(variables:Array<ASAny>, selectedMode:Int):Bool
        {
var variable:WiredVariable  = null;            if (selectedMode == SOURCE_VALUE || variables.length == 0) return true;
            if (checkNullIteratee(variables)) for (_tmp_ in variables) {variable = _tmp_;
if (variable.hasValue) return true;
};
            return false;
        }

        function showCreationTime(variables:Array<ASAny>, selectedMode:Int):Bool
        {
var variable:WiredVariable  = null;            if (selectedMode == SOURCE_CREATION_TIME || variables.length == 0) return true;
            if (checkNullIteratee(variables)) for (_tmp_ in variables)
{variable = _tmp_;
                if (variable.canReadCreationTime) return true;
};
            return false;
        }

        function showLastUpdateTime(variables:Array<ASAny>, selectedMode:Int):Bool
        {
var variable:WiredVariable  = null;            if (selectedMode == SOURCE_LAST_UPDATE_TIME || variables.length == 0) return true;
            if (checkNullIteratee(variables)) for (_tmp_ in variables)
{variable = _tmp_;
                if (variable.canReadLastUpdateTime) return true;
};
            return false;
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._standard.mask | this._advanced.mask, this._mode.selectedId];
        }

	public function new() { super(); }
    }

