package com.sulake.habbo.roomevents.wired_setup.addons
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July addon 22: numeric or variable-driven movement curve. */
     class JumpStrengthAddonElement extends DefaultElement
    {
        var _strength:ValueOrVariableSection;
        override public function  get_code():Int { return AddonCodes.JUMP_STRENGTH; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int { return WiredCapabilityCodes.ADDONS | WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC; }
        override public function buildInputs(m:PresetManager, s:WiredStyle, b:WiredUIBuilder)
        {
            this._strength = m.createValueOrVariableSection(0, this.mergedSourceOptions(0), this.l("jump_strength"), -1000, 1000);
            b.addElements([this._strength]);
        }
        override public function onEditStart(d:Triggerable)
        {
            var v=d.intData; var id=d.variableIds.length>0?ASCompat.toString(d.variableIds[0]):null;
            var option=v.length>0?ASCompat.toInt(v[0]):0; var value=v.length>1?ASCompat.toInt(v[1]):80; var target=v.length>2?ASCompat.toInt(v[2]):0;
            if(option==0) id=WiredVariable.NONE_ID; else value=80;
            this._strength.init(d.wiredContext.roomVariablesList,id,target,option,value);
        }
        override public function onEditInitialized() { this._strength.onEditInitialized(); }
        override public function readIntParamsFromForm():Array<ASAny> { return [this._strength.option,this._strength.numberValue,this._strength.target]; }
        override public function readVariableIdsFromForm():Array<ASAny> { return [this._strength.finalizeSelection]; }
        override public function isInputSourceDisabled(t:Int,i:Int):Bool { return t==WiredInputSourcePicker.MERGED_SOURCE && this._strength.isSourcePickingDisabled(); }
        override public function mergedSelectionTitle(i:Int):String { return "wiredfurni.params.sources.merged.title.variables_reference"; }
        override public function mergedSelections():Array<ASAny> { return [([0,0] : Array<Dynamic>)]; }
        override public function setMergedType(i:Int,v:Int) { this._strength.target=v; }
        override public function getMergedType(i:Int):Int { return this._strength.target; }
        override public function getCustomSourcesForMergedType(i:Int):Array<ASAny> { return [VariableExtraSourceTypes.GLOBAL_SOURCE,VariableExtraSourceTypes.CONTEXT_SOURCE]; }
        override public function hasCustomTypePicker(i:Int):Bool { return true; }
        override public function advancedAlwaysVisible():Bool { return true; }
        override public function  get_forceHidePickFurniInstructions():Bool { return true; }

	public function new() { super(); }
    }

