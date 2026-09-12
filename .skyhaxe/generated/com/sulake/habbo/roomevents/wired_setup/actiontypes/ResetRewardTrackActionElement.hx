package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.combinations.NamedTextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class ResetRewardTrackActionElement extends DefaultElement
    {
        var _trackId:NamedTextInputPreset;

        override public function  get_code():Int { return ActionTypeCodes.RESET_REWARD_TRACK; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._trackId = manager.createNamedTextInput(
                new TextInputParam("", 100, null, -1, "^\t"),
                "${wiredfurni.params.reward_track.track_id}");
            builder.addElements([manager.createSection(
                "${wiredfurni.params.reward_track.reset.track}", this._trackId)]);
        }

        override public function onEditStart(data:Triggerable)
        {
            this._trackId.text = data.stringData;
        }
        override public function readStringParamFromForm():String { return this._trackId.text; }
        override public function advancedAlwaysVisible():Bool { return true; }
        override public function  get_forceHidePickFurniInstructions():Bool { return true; }

	public function new() { super(); }
    }

