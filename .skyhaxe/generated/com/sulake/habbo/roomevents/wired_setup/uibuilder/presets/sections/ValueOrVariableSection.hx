package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.AllVariablesInRoom;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.ISourceTypeListener;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SourceTypeSelectorParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.NumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SourceTypeSelectorPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.VariablePickerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July AIR value-or-variable editor used by Change Variable (action 41). */
     class ValueOrVariableSection extends AbstractSectionPreset implements ISourceTypeListener
    {
        var _optionGroup:RadioGroupPreset;
        var _numberInput:NumberInputPreset;
        var _picker:VariablePickerPreset;
        var _sourceSelector:SourceTypeSelectorPreset;
        var _mergedSelectionId:Int = 0;
        var _target:Int = 0;

        public function new(roomEvents:HabboUserDefinedRoomEvents,
                                               manager:PresetManager,
                                               style:WiredStyle,
                                               mergedSelectionId:Int,
                                               sourceOptions:Array<ASAny>,
                                               title:String,
                                               minimum:Int,
                                               maximum:Int)
        {
            super(roomEvents, manager, style);
            this._mergedSelectionId = mergedSelectionId;
            this._numberInput = manager.createNumberInput(
                new NumberInputParam(0, minimum, maximum, 45, 0, false, true));
            this._sourceSelector = manager.createSourceTypeSelector(
                new SourceTypeSelectorParam(sourceOptions, this));
            this._picker = manager.createVariablePicker(this.variableSelectionFilter);
            this._optionGroup = manager.createRadioGroup([
                new RadioButtonParam(0, this.l("variables.reference_value.set_value"), this._numberInput),
                new RadioButtonParam(1, this.l("variables.reference_value.from_variable"),
                    this._sourceSelector.alignRight(), this._picker)
            ], this.onChangeRadioOption);
            this.initializeSection(title, this._optionGroup);
        }

        function variableSelectionFilter(value:WiredVariable):Bool
        {
            return value != null && value.hasValue;
        }

        public function init(variables:AllVariablesInRoom, variableId:String,
                             target:Int, option:Int, value:Int)
        {
            this._picker.init(variables, variableId, target);
            this._target = target;
            this._optionGroup.selected = option;
            this._numberInput.value = value;
        }

        public function onEditInitialized()
        {
            this._sourceSelector.select(this._target);
        }

        
        public var target(get,set):Int;
public function  set_target(value:Int):Int        {
            this._target = value;
            return this._picker.variableTarget = value;
        }
public function  get_target():Int { return this._target; }
        public var option(get,never):Int;
public function  get_option():Int { return this._optionGroup.selected; }
        public var numberValue(get,never):Int;
public function  get_numberValue():Int { return this._numberInput.value; }
        public var finalizeSelection(get,never):String;
public function  get_finalizeSelection():String { return this._picker.finalizeSelection; }

        function onChangeRadioOption(value:Int)
        {
            this._roomEvents.wiredCtrl.updateSourceContainer(
                WiredInputSourcePicker.MERGED_SOURCE, this._mergedSelectionId);
        }

        public function isSourcePickingDisabled():Bool
        {
            return this._optionGroup.selected == 0;
        }

        public var sourceType(never,set):Int;
public function  set_sourceType(value:Int):Int        {
            this._roomEvents.wiredCtrl.setMergedSourceType(this._mergedSelectionId, value);
return value;
        }

        override public function dispose()
        {
            if (disposed) { return; }
            super.dispose();
            this._optionGroup = null;
            this._numberInput = null;
            this._picker = null;
            this._sourceSelector = null;
        }
    }

