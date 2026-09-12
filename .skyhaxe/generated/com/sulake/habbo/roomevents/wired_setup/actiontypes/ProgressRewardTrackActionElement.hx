package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.VariableExtraSourceTypes;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.CheckboxOptionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.CheckboxOptionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedTextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.ValueOrVariableSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class ProgressRewardTrackActionElement extends DefaultElement
    {
        var _trackId:NamedTextInputPreset;
        var _taskId:NamedTextInputPreset;
        var _addToExisting:CheckboxOptionPreset;
        var _score:ValueOrVariableSection;

        override public function  get_code():Int { return ActionTypeCodes.PROGRESS_REWARD_TRACK; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._trackId = manager.createNamedTextInput(
                new TextInputParam("", 100, null, -1, "a-zA-Z0-9_"),
                "${wiredfurni.params.reward_track.track_id}");
            this._taskId = manager.createNamedTextInput(
                new TextInputParam("", 100, null, -1, "a-zA-Z0-9_"),
                "${wiredfurni.params.reward_track.task_id}");
            var identifiers= manager.createSimpleListView(
                true, [this._trackId, this._taskId]);
            var identifiersSection= manager.createSection(
                "${wiredfurni.params.reward_track.progress.ids}", identifiers);
            this._addToExisting = manager.createCheckboxOption(
                new CheckboxOptionParam(
                    "${wiredfurni.params.reward_track.add_to_existing_score}"));
            var modeSection= manager.createSection(
                "${wiredfurni.params.reward_track.progress.mode}", this._addToExisting);
            this._score = manager.createValueOrVariableSection(
                0, mergedSourceOptions(0),
                "${wiredfurni.params.reward_track.score}", 1, ASCompat.MAX_INT);
            builder.addElements([identifiersSection, modeSection, this._score]);
        }

        override public function onEditStart(data:Triggerable)
        {
            var parts:Array<ASAny> = data.stringData != null ? (cast data.stringData.split("\t")) : [];
            this._trackId.text = parts.length > 0 ? ASCompat.toString(parts[0]) : "";
            this._taskId.text = parts.length > 1 ? ASCompat.toString(parts[1]) : "";
            this._addToExisting.selected = data.intData.length > 0 &&
                ASCompat.toInt(data.intData[0]) != 0;
            var variableId= data.variableIds.length > 0
                ? ASCompat.toString(data.variableIds[0]) : WiredVariable.NONE_ID;
            var option= data.intData.length > 1 ? ASCompat.toInt(data.intData[1]) : 0;
            var value= data.intData.length > 2 ? ASCompat.toInt(data.intData[2]) : 1;
            var target= data.intData.length > 3 ? ASCompat.toInt(data.intData[3]) : 0;
            if (option == 0) { variableId = WiredVariable.NONE_ID; }
            this._score.init(data.wiredContext.roomVariablesList,
                variableId, target, option, value);
        }

        override public function onEditInitialized() { this._score.onEditInitialized(); }
        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._addToExisting.selected ? 1 : 0, this._score.option,
                this._score.numberValue, this._score.target];
        }
        override public function readStringParamFromForm():String
        {
            return this._trackId.text + "\t" + this._taskId.text;
        }
        override public function readVariableIdsFromForm():Array<ASAny>
        {
            return [this._score.finalizeSelection];
        }
        override public function mergedSelections():Array<ASAny> { return [([0, 1] : Array<Dynamic>)]; }
        override public function mergedSelectionTitle(index:Int):String
        {
            return "wiredfurni.params.sources.merged.title.variables_reference";
        }
        override public function setMergedType(index:Int, value:Int)
        {
            this._score.target = value;
        }
        override public function getMergedType(index:Int):Int { return this._score.target; }
        override public function getCustomSourcesForMergedType(index:Int):Array<ASAny>
        {
            return [VariableExtraSourceTypes.GLOBAL_SOURCE,
                VariableExtraSourceTypes.CONTEXT_SOURCE];
        }
        override public function isInputSourceDisabled(index:Int, type:Int):Bool
        {
            return type == WiredInputSourcePicker.MERGED_SOURCE &&
                this._score.isSourcePickingDisabled();
        }
        override public function hasCustomTypePicker(index:Int):Bool { return true; }
        override public function advancedAlwaysVisible():Bool { return true; }
        override public function  get_forceHidePickFurniInstructions():Bool { return true; }

	public function new() { super(); }
    }

