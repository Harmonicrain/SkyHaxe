package com.sulake.habbo.roomevents.wired_setup.actiontypes.chests
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.RadioButtonParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.RadioGroupPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July action 46: give matching furniture from a selected furni chest. */
     class GiveFurniFromChestActionElement extends GiveFromChestActionElement
    {
        var _iteration:RadioGroupPreset;
        var _iterationSection:SectionPreset;

        override public function  get_code():Int { return ActionTypeCodes.GIVE_FURNI_FROM_CHEST; }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            var values= super.readIntParamsFromForm();
            values.push(this._iteration.selected);
            return values;
        }

        override public function onEditStart(definition:Triggerable)
        {
            super.onEditStart(definition);
            this._iteration.selected = definition.intData.length > 5 ?
                ASCompat.toInt(definition.intData[5]) : 0;
            this._iterationSection.disabled = this.rewardingMode == GiveFromChestActionElement.MODE_ALL;
        }

        override function onModeChange(value:Int)
        {
            super.onModeChange(value);
            this._iterationSection.disabled = value == GiveFromChestActionElement.MODE_ALL;
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._iteration = manager.createRadioGroup([
                new RadioButtonParam(0, this.l("chest_iteration_type.0")),
                new RadioButtonParam(1, this.l("chest_iteration_type.1")),
                new RadioButtonParam(2, this.l("chest_iteration_type.2"))
            ]);
            this._iterationSection = manager.createSection(this.l("chest_iteration_type"),
                this._iteration, SectionParam.COLLAPSED);
            super.buildInputs(manager, style, builder);
        }

        override function finalizeBuilding(builder:WiredUIBuilder)
        {
            super.finalizeBuilding(builder);
            builder.addElements([this._iterationSection]);
        }

	public function new() { super(); }
    }

