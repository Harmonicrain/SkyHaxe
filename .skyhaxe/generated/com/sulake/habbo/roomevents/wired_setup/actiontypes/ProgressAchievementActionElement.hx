package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class ProgressAchievementActionElement extends DefaultElement
    {
        var _achievement:DropdownPreset;
        var _mode:RadioGroupPreset;
        var _value:ValueOrVariableSection;
        override public function  get_code():Int { return ActionTypeCodes.PROGRESS_ACHIEVEMENT; }
        override public function  get_negativeCode():Int { return ActionTypeCodes.PROGRESS_ACHIEVEMENT; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function buildInputs(m:PresetManager,s:WiredStyle,b:WiredUIBuilder)
        {
            this._achievement=m.createDropdown(new DropdownParam(this.l("progress_achievement.name")));
            this._mode=m.createRadioGroup([new RadioButtonParam(1,this.l("progress_achievement.mode.1")),new RadioButtonParam(0,this.l("progress_achievement.mode.0"))]);
            this._value=m.createValueOrVariableSection(0,this.mergedSourceOptions(0),this.l("progress_achievement.score"),0,2147483647);
            b.addElements([m.createSection(this.l("progress_achievement.name"),this._achievement),m.createSection(this.l("progress_achievement.mode"),this._mode),this._value]);
        }
        override public function onEditStart(d:Triggerable)
        {
var name:String  = null, option:ExpandableDropdownOption  = null;            var options=new Vector<ExpandableDropdownOption>();
            final _iter_ = this.roomEvents.achievementsInRoom; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) {name = _tmp_;
options.push(new ExpandableDropdownOption(options.length,name));
};
            this._achievement.reinit(options,-1);
            if (checkNullIteratee(options)) for (_tmp_ in options) {option = _tmp_;
if(option.displayString==d.stringData)this._achievement.selectedId=option.id;
};
            this._mode.selected=d.intData.length>0?ASCompat.toInt(d.intData[0]):1;
            this._value.init(d.wiredContext.roomVariablesList,d.variableIds.length>0?ASCompat.toString(d.variableIds[0]):null,d.intData.length>3?ASCompat.toInt(d.intData[3]):0,d.intData.length>1?ASCompat.toInt(d.intData[1]):0,d.intData.length>2?ASCompat.toInt(d.intData[2]):0);
        }
        override public function onEditInitialized() { this._value.onEditInitialized(); }
        override public function readIntParamsFromForm():Array<ASAny>{return [this._mode.selected,this._value.option,this._value.numberValue,this._value.target];}
        override public function readStringParamFromForm():String{return this._achievement.selected==null?"":this._achievement.selected.displayString;}
        override public function readVariableIdsFromForm():Array<ASAny>{return [this._value.finalizeSelection];}
        override public function mergedSelections():Array<ASAny>{return [([0,1] : Array<Dynamic>)];}
        override public function setMergedType(i:Int,v:Int){this._value.target=v;}
        override public function getMergedType(i:Int):Int{return this._value.target;}
        override public function getCustomSourcesForMergedType(i:Int):Array<ASAny>{return [VariableExtraSourceTypes.GLOBAL_SOURCE,VariableExtraSourceTypes.CONTEXT_SOURCE];}
        override public function isInputSourceDisabled(i:Int,t:Int):Bool{return t==WiredInputSourcePicker.MERGED_SOURCE&&this._value.isSourcePickingDisabled();}
        override public function hasCustomTypePicker(i:Int):Bool{return true;}
        override public function  get_forceHidePickFurniInstructions():Bool{return true;}

	public function new() { super(); }
    }

