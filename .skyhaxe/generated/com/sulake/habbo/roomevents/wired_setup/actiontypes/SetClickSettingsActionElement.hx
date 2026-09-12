package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.common.advanced_dropdown.ExpandableDropdownOption;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.DropdownParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.DropdownPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July action 54 (wf_act_click_conf): [userMode 0..2, furniMode 0..1]. */
     class SetClickSettingsActionElement extends DefaultElement
    {
        var _userMode:DropdownPreset;
        var _furniMode:DropdownPreset;

        override public function  get_code():Int
        {
            return ActionTypeCodes.SET_CLICK_SETTINGS;
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function buildInputs(_arg_1:PresetManager, _arg_2:WiredStyle, _arg_3:WiredUIBuilder)
        {
            this._userMode = _arg_1.createDropdown(new DropdownParam("${wiredfurni.params.click_settings.user}", Vector.ofArray([
                new ExpandableDropdownOption(0, "${wiredfurni.params.click_settings.user.0}"),
                new ExpandableDropdownOption(1, "${wiredfurni.params.click_settings.user.1}"),
                new ExpandableDropdownOption(2, "${wiredfurni.params.click_settings.user.2}")
            ])));
            this._furniMode = _arg_1.createDropdown(new DropdownParam("${wiredfurni.params.click_settings.furni}", Vector.ofArray([
                new ExpandableDropdownOption(0, "${wiredfurni.params.click_settings.furni.0}"),
                new ExpandableDropdownOption(1, "${wiredfurni.params.click_settings.furni.1}")
            ])));
            _arg_3.addElements(
                [_arg_1.createSection("${wiredfurni.params.click_settings.user}", this._userMode),
                _arg_1.createSection("${wiredfurni.params.click_settings.furni}", this._furniMode)]
            );
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._userMode.selectedId, this._furniMode.selectedId];
        }

        override public function onEditStart(k:Triggerable)
        {
            this._userMode.selectedId = ASCompat.toInt(k.intData.length > 0 ? ASCompat.toInt(k.intData[0] ): 0);
            this._furniMode.selectedId = ASCompat.toInt(k.intData.length > 1 ? ASCompat.toInt(k.intData[1] ): 0);
        }

	public function new() { super(); }
    }

