package com.sulake.habbo.roomevents.wired_setup.variables
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.VariableNameSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class QuestVariableElement extends VariableElement
    {
        static inline final SPLITTER= "\t";
        var _variableName:VariableNameSection;
        var _questName:TextInputPreset;

        override public function  get_code():Int { return VariableCodes.QUEST_VARIABLE; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._variableName = manager.createVariableNameSection();
            this._questName = manager.createTextInput(new TextInputParam("", 500));
            builder.addElements([this._variableName, manager.createSection(
                l("variables.quest_name"), this._questName)]);
        }
        override public function onEditStart(data:Triggerable)
        {
            super.onEditStart(data);
            var parts:Array<ASAny> = (cast data.stringData.split(SPLITTER));
            this.initialVariableName = parts.length > 0 ? ASCompat.toString(parts[0]) : "";
            this._questName.text = parts.length > 1 ? ASCompat.toString(parts[1]) : "";
        }
        override public function readStringParamFromForm():String
        {
            return this._variableName.variableName + SPLITTER + this._questName.text;
        }
        override public function variableType():Int { return VariableTargets.USER; }
        override function  get_variableNameSection():VariableNameSection
        {
            return this._variableName;
        }

	public function new() { super(); }
    }

