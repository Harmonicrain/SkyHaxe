package com.sulake.habbo.roomevents.wired_setup.variables
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariableTypes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ChooseVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.VariableNameSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class EchoVariableElement extends VariableElement
    {
        var _variableName:VariableNameSection;
        var _variable:ChooseVariableSection;
        var _initialVariable:WiredVariable;

        override public function  get_code():Int { return VariableCodes.ECHO_VARIABLE; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._variableName = manager.createVariableNameSection();
            this._variable = manager.createChooseVariableSection(-1, [
                WiredInputSourcePicker.FURNI_SOURCE,
                WiredInputSourcePicker.USER_SOURCE,
                VariableExtraSourceTypes.GLOBAL_SOURCE,
                VariableExtraSourceTypes.CONTEXT_SOURCE
            ], this.variableSelectionFilter, this.onVariableSelected);
            builder.addElements([this._variableName, this._variable]);
        }
        function variableSelectionFilter(value:WiredVariable):Bool
        {
            return value != null && value.variableType != WiredVariableTypes.DYNAMIC;
        }
        override public function onEditStart(data:Triggerable)
        {
            var variableId= data.variableIds.length > 0
                ? ASCompat.toString(data.variableIds[0]) : WiredVariable.NONE_ID;
            var target= WiredInputSourcePicker.USER_SOURCE;
            var selected= findVariable(data.wiredContext.roomVariablesList.variables,
                variableId);
            if (selected != null) { target = selected.variableTarget; }
            this._variable.init(data.wiredContext.roomVariablesList, variableId, target);
            this._initialVariable = this._variable.selected;
            this.initialVariableName = data.stringData;
        }
        override public function onEditInitialized() { this._variable.onEditInitialized(); }
        override public function readStringParamFromForm():String
        {
            return this._variableName.variableName;
        }
        override public function readVariableIdsFromForm():Array<ASAny>
        {
            return [this._variable.finalizeSelection];
        }
        function onVariableSelected(value:WiredVariable)
        {
            if (this._variableName.variableName.length == 0 ||
                this._initialVariable != null &&
                defaultEchoName(this._initialVariable) == this._variableName.variableName)
            {
                this._variableName.variableName = value == null ? "" : defaultEchoName(value);
            }
            this._initialVariable = value;
        }
        static function defaultEchoName(value:WiredVariable):String
        {
            return new compat.RegExp("\\.", "g").replace(ASCompat.stringReplace(ASCompat.stringReplace(value.variableName, "@", ""), "~", ""), "_");
        }
        static function findVariable(variables:Array<ASAny>, id:String):WiredVariable
        {
var value:WiredVariable  = null;            if (checkNullIteratee(variables)) for (_tmp_ in variables)
            {
value = _tmp_;
                if (value.variableId == id) { return value; }
            }
            return null;
        }
        override public function variableType():Int { return this._variable.target; }
        override function  get_variableNameSection():VariableNameSection
        {
            return this._variableName;
        }

	public function new() { super(); }
    }

