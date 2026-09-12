package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextInputParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextInputPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July AIR actions 49/50. Both codes share the same log-level/message editor. */
     class WriteToLogsActionElement extends DefaultElement
    {
        var _level:DropdownPreset;
        var _message:TextInputPreset;

        override public function  get_code():Int
        {
            return ActionTypeCodes.WRITE_TO_LOGS;
        }

        override public function  get_negativeCode():Int
        {
            return ActionTypeCodes.NEG_WRITE_TO_LOGS;
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.MENU_LOGS;
        }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            var levels=
                new Vector<ExpandableDropdownOption>();
            levels.push(new ExpandableDropdownOption(
                0, "${wiredfurni.params.write_to_logs.log_level.0}"));
            levels.push(new ExpandableDropdownOption(
                1, "${wiredfurni.params.write_to_logs.log_level.1}"));
            levels.push(new ExpandableDropdownOption(
                2, "${wiredfurni.params.write_to_logs.log_level.2}"));
            levels.push(new ExpandableDropdownOption(
                3, "${wiredfurni.params.write_to_logs.log_level.3}"));
            this._level = manager.createDropdown(new DropdownParam(
                "${wiredfurni.params.write_to_logs.log_level.title}", levels));
            this._message = manager.createTextInput(new TextInputParam("", 400));
            builder.addElements(
                [manager.createSection(
                    "${wiredfurni.params.write_to_logs.log_level.title}", this._level),
                manager.createSection(
                    "${wiredfurni.params.write_to_logs.log_message.title}", this._message)]);
        }

        override public function onEditStart(data:Triggerable)
        {
            this._level.selectedId =
                data.intData.length > 0 ? ASCompat.toInt(data.intData[0]) : 0;
            this._message.text = data.stringData != null ? data.stringData : "";
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._level.selectedId];
        }

        override public function readStringParamFromForm():String
        {
            return this._message.text;
        }

	public function new() { super(); }
    }

