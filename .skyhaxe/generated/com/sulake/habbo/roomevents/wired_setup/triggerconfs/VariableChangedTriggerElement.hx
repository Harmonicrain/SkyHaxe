package com.sulake.habbo.roomevents.wired_setup.triggerconfs
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.AllVariablesInRoom;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariableTypes;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.WiredTriggerType;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.ISourceTypeListener;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SourceTypeSelectorParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.VariablePickerPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.wired_setup.variables.VariableAvailabilityTypes;

    /** July AIR trigger 22: created/value-changed/deleted variable mutation filter. */
     class VariableChangedTriggerElement extends DefaultElement implements ISourceTypeListener
    {
        static inline final CREATED_INDEX= 0;
        static inline final VALUE_CHANGED_INDEX= 1;
        static inline final DELETED_INDEX= 2;

        var _variableSection:SectionPreset;
        var _picker:VariablePickerPreset;
        var _optionGroup:CheckboxGroupPreset;
        var _changeDirectionGroup:CheckboxGroupPreset;

        override public function  get_code():Int { return WiredTriggerType.VARIABLE_CHANGED; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC;
        }

        static function variableSelectionFilter(value:WiredVariable):Bool
        {
            return value != null && value.canInterceptChanges;
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle, builder:WiredUIBuilder)
        {
            var targetSelector= new SourceTypeSelectorParam([
                WiredInputSourcePicker.FURNI_SOURCE,
                WiredInputSourcePicker.USER_SOURCE,
                VariableExtraSourceTypes.GLOBAL_SOURCE
            ], this);
            this._picker = manager.createVariablePicker(variableSelectionFilter, this.onChangeVariable);
            this._variableSection = manager.createSection(
                this.loc("wiredfurni.params.variables.variable_selection"),
                this._picker,
                new SectionParam(targetSelector));

            this._changeDirectionGroup = manager.createCheckboxGroup([
                new CheckboxOptionParam(this.l("variables.trigger_options.1.0"), 0),
                new CheckboxOptionParam(this.l("variables.trigger_options.1.1"), 1),
                new CheckboxOptionParam(this.l("variables.trigger_options.1.2"), 2)
            ]);
            var valueChanged= new CheckboxOptionParam(
                this.l("variables.trigger_options.1"), VALUE_CHANGED_INDEX);
            valueChanged.extra2 = this._changeDirectionGroup;
            this._optionGroup = manager.createCheckboxGroup([
                new CheckboxOptionParam(this.l("variables.trigger_options.0"), CREATED_INDEX),
                valueChanged,
                new CheckboxOptionParam(this.l("variables.trigger_options.2"), DELETED_INDEX)
            ]);
            builder.addElements([this._variableSection,
                manager.createSection(this.l("variables.trigger_options"), this._optionGroup)]);
        }

        override public function onEditStart(definition:Triggerable)
        {
            var selectedId= definition.variableIds.length > 0 ? ASCompat.toString(definition.variableIds[0]) : null;
            var target= WiredInputSourcePicker.USER_SOURCE;
            var variables:AllVariablesInRoom = definition.wiredContext == null
                ? null : definition.wiredContext.roomVariablesList;
            var selected= findVariableById(variables, selectedId);
            if (selected != null) { target = selected.variableTarget; }
            this._variableSection.getSourceTypeSelector().select(target);
            this._picker.init(variables, selectedId, target);
            this.onChangeVariable(this._picker.selected);
            this._optionGroup.get(CREATED_INDEX).selected = definition.getBoolean(0);
            this._optionGroup.get(VALUE_CHANGED_INDEX).selected = definition.getBoolean(1);
            this._optionGroup.get(DELETED_INDEX).selected = definition.getBoolean(2);
            this._changeDirectionGroup.mask = definition.intData.length > 3 ? ASCompat.toInt(definition.intData[3]) : 0;
        }

        static function findVariableById(variables:AllVariablesInRoom, id:String):WiredVariable
        {
var value:WiredVariable  = null;            if (variables == null || variables.variables == null) { return null; }
            final _iter_ = variables.variables; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
value = _tmp_;
                if (value.variableId == id) { return value; }
            }
            return null;
        }

        function onChangeVariable(value:WiredVariable)
        {
            var supportsCreateDelete= value == null || value.canCreateAndDelete;
            var specialAvailability= value != null &&
                (value.variableType == WiredVariableTypes.USER_CREATED_SPECIAL ||
                 value.availabilityType == VariableAvailabilityTypes.SHARED_DYNAMIC);
            var dynamicOrInternal= value != null &&
                (value.variableType == WiredVariableTypes.DYNAMIC || value.variableType == WiredVariableTypes.INTERNAL);
            var supportsValue= value == null || value.hasValue;
            this._optionGroup.get(CREATED_INDEX).disabled =
                !supportsCreateDelete && !specialAvailability && !dynamicOrInternal;
            this._optionGroup.get(VALUE_CHANGED_INDEX).disabled = !supportsValue && !dynamicOrInternal;
            this._optionGroup.get(DELETED_INDEX).disabled =
                !supportsCreateDelete && !specialAvailability && !dynamicOrInternal;
        }

        public var sourceType(never,set):Int;
public function  set_sourceType(value:Int):Int{ return this._picker.variableTarget = value; }

        override public function readVariableIdsFromForm():Array<ASAny> { return [this._picker.finalizeSelection]; }
        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [
                this._optionGroup.get(CREATED_INDEX).selected ? 1 : 0,
                this._optionGroup.get(VALUE_CHANGED_INDEX).selected ? 1 : 0,
                this._optionGroup.get(DELETED_INDEX).selected ? 1 : 0,
                this._changeDirectionGroup.mask
            ];
        }

	public function new() { super(); }
    }

