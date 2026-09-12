package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariableTypes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.NumberInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.NumberInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ChooseVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    import com.sulake.habbo.roomevents.wired_setup.variables.VariableTargets;

    /** July ordinary Place Furni editor. Wire payload is the July ten-int/two-variable contract. */
     class PlaceFurniActionElement extends DefaultElement
    {
        var _location:RadioGroupPreset;
        var _altitude:RadioGroupPreset;
        var _offsets:CheckboxGroupPreset;
        var _x:NumberInputPreset;
        var _y:NumberInputPreset;
        var _z:NumberInputPreset;
        var _spawn:CheckboxGroupPreset;
        var _spawnSection:SectionPreset;
        var _spawnVariable:ChooseVariableSection;
        var _reference:ValueOrVariableSection;
        var _targetIsUser:Bool = false;

        override public function  get_code():Int { return ActionTypeCodes.PLACE_FURNI; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_hasStateSnapshot():Bool { return true; }

        function filterSpawnVariable(value:WiredVariable):Bool
        {
            return value != null && value.variableTarget == VariableTargets.FURNI &&
                value.canCreateAndDelete && value.variableType == WiredVariableTypes.USER_CREATED;
        }

        override public function buildInputs(m:PresetManager, style:WiredStyle, b:WiredUIBuilder)
        {
            var soft= new TextParam(1);
            soft.textColor = style.softTextColor;
            this._location = m.createRadioGroup([
                new RadioButtonParam(0, l("place_furni.target_location.0"), null,
                    m.createText(l("place_furni.target_location.0.info"), soft)),
                new RadioButtonParam(1, l("place_furni.target_location.1"))], this.onLocation);
            this._altitude = m.createRadioGroup([
                new RadioButtonParam(0, l("place_furni.target_altitude.0")),
                new RadioButtonParam(1, l("place_furni.target_altitude.1")),
                new RadioButtonParam(2, l("place_furni.target_altitude.2"))], this.onAltitude);
            this._x = m.createNumberInput(new NumberInputParam(0, -64, 64));
            this._y = m.createNumberInput(new NumberInputParam(0, -64, 64));
            this._z = m.createNumberInput(new NumberInputParam(0, -8000, 8000));
            this._offsets = m.createCheckboxGroup([
                new CheckboxOptionParam(l("place_furni.offsets.x"), 0, this._x),
                new CheckboxOptionParam(l("place_furni.offsets.y"), 1, this._y),
                new CheckboxOptionParam(l("place_furni.offsets.altitude"), 2, this._z)]);
            this._spawnVariable = m.createChooseVariableSection(-1, null, this.filterSpawnVariable, this.onSpawnVariable);
            this._reference = m.createValueOrVariableSection(1, this.mergedSourceOptions(1),
                l("place_furni.spawn_with_value"), Std.int(-2147483648), 2147483647);
            this._spawn = m.createCheckboxGroup([new CheckboxOptionParam(
                l("place_furni.spawn_with_variable"), 0, null,
                m.createSimpleListView(true, [this._spawnVariable, this._reference]))], this.onSpawn);
            this._spawnSection = m.createSection(l("place_furni.spawn_with_variable"),
                this._spawn, SectionParam.COLLAPSED);
            b.addElements([m.createUsageInfoSection(l("place_furni.usage_info")),
                m.createSection(l("place_furni.target_location"), this._location, SectionParam.EXPANDED_WITH_TOGGLE),
                m.createSection(l("place_furni.target_altitude"), this._altitude, SectionParam.EXPANDED_WITH_TOGGLE),
                m.createSection(l("place_furni.offsets"), this._offsets, SectionParam.COLLAPSED),
                this._spawnSection]);
            this.updateReference();
        }

        override public function onEditStart(d:Triggerable)
        {
            var a= d.intData;
            this._targetIsUser = a.length > 0 && a[0] == 1;
            this._location.selected = ASCompat.toInt(a.length > 1 ? ASCompat.toInt(a[1] ): 0);
            this._altitude.selected = ASCompat.toInt(a.length > 2 ? ASCompat.toInt(a[2] ): 0);
            this.setOffset(0, this._x, ASCompat.toInt(a.length > 3 ? ASCompat.toInt(a[3] ): 0));
            this.setOffset(1, this._y, ASCompat.toInt(a.length > 4 ? ASCompat.toInt(a[4] ): 0));
            this.setOffset(2, this._z, ASCompat.toInt(a.length > 5 ? ASCompat.toInt(a[5] ): 0));
            this._spawn.get(0).selected = a.length > 6 && a[6] == 1;
            this._spawnVariable.init(d.wiredContext.roomVariablesList,
                d.variableIds.length > 0 ? d.variableIds[0] : WiredVariable.NONE_ID, VariableTargets.FURNI);
            this._reference.init(d.wiredContext.roomVariablesList,
                d.variableIds.length > 1 ? d.variableIds[1] : WiredVariable.NONE_ID,
                ASCompat.toInt(a.length > 9 ? ASCompat.toInt(a[9] ): 0), ASCompat.toInt(a.length > 7 ? ASCompat.toInt(a[7] ): 0), ASCompat.toInt(a.length > 8 ? ASCompat.toInt(a[8] ): 0));
            this.updateReference();
            this._spawnSection.updateDisabledState();
        }

        override public function onEditInitialized()
        {
            this._spawnVariable.onEditInitialized();
            this._reference.onEditInitialized();
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            var enabled= this._spawn.get(0).selected && !this._reference.disabled;
            return [this._targetIsUser ? 1 : 0, this._location.selected, this._altitude.selected,
                this.offset(0, this._x), this.offset(1, this._y), this.offset(2, this._z),
                this._spawn.get(0).selected ? 1 : 0, enabled ? this._reference.option : 0,
                enabled ? this._reference.numberValue : 0, this._reference.target];
        }

        override public function readVariableIdsFromForm():Array<ASAny>
        {
            var enabled= this._spawn.get(0).selected && !this._reference.disabled;
            return [this._spawn.get(0).selected ? this._spawnVariable.finalizeSelection : WiredVariable.NONE_ID,
                enabled && this._reference.option == 1 ? this._reference.finalizeSelection : WiredVariable.NONE_ID];
        }

        override public function mergedSelections():Array<ASAny> { return [([1, 0] : Array<Dynamic>), ([2, 1] : Array<Dynamic>)]; }
        override public function setMergedType(i:Int, value:Int)
        {
            if (i == 0) this._targetIsUser = value == WiredInputSourcePicker.USER_SOURCE;
            else this._reference.target = value;
        }
        override public function getMergedType(i:Int):Int
        {
            return i == 0 ? (this._targetIsUser ? WiredInputSourcePicker.USER_SOURCE : WiredInputSourcePicker.FURNI_SOURCE) : this._reference.target;
        }
        override public function isInputSourceDisabled(i:Int, type:Int):Bool
        {
            if (type != WiredInputSourcePicker.MERGED_SOURCE) return false;
            return i == 0 ? !(this._location.selected == 1 || this._altitude.selected == 2) :
                !this._spawn.get(0).selected || this._reference.disabled || this._reference.isSourcePickingDisabled();
        }
        override public function hasCustomTypePicker(i:Int):Bool { return i == 1; }
        override public function getCustomSourcesForMergedType(i:Int):Array<ASAny>
        {
            return i == 1 ? [VariableExtraSourceTypes.GLOBAL_SOURCE, VariableExtraSourceTypes.CONTEXT_SOURCE] : [];
        }
        override public function furniSelectionTitle(i:Int):String { return "wiredfurni.params.sources.furni.title.place_furni"; }
        override public function mergedSelectionTitle(i:Int):String
        {
            return i == 0 ? "wiredfurni.params.sources.merged.title.custom_target" :
                "wiredfurni.params.sources.merged.title.variables_reference";
        }
        override public function  get_forceHidePickFurniInstructions():Bool { return true; }
        override public function  get_widthModifier():Float { return 1.2; }

        function offset(i:Int, input:NumberInputPreset):Int { return this._offsets.get(i).selected ? input.value : 0; }
        function setOffset(i:Int, input:NumberInputPreset, value:Int)
        {
            input.value = value; this._offsets.get(i).selected = value != 0;
        }
        function onLocation(value:Int) { this.updateSources(); }
        function onAltitude(value:Int) { this.updateSources(); }
        function onSpawn(i:Int, selected:Bool) { this.updateReference(); }
        function onSpawnVariable(value:WiredVariable) { this.updateReference(); }
        function updateSources() { roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.MERGED_SOURCE, 0); }
        function updateReference()
        {
            var selected= this._spawnVariable.selected;
            this._reference.disabled = !this._spawn.get(0).selected || selected == null || !selected.hasValue;
            roomEvents.wiredCtrl.updateSourceContainer(WiredInputSourcePicker.MERGED_SOURCE, 1);
        }

	public function new() { super(); }
    }

