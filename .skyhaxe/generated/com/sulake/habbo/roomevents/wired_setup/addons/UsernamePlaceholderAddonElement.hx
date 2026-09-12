package com.sulake.habbo.roomevents.wired_setup.addons
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.PlaceholderNameSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections.PlaceholderTypeSection;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

    /** July addon 14: username placeholder definition. */
     class UsernamePlaceholderAddonElement extends DefaultElement
    {
        var _name:PlaceholderNameSection;
        var _type:PlaceholderTypeSection;

        override public function  get_code():Int { return AddonCodes.USERNAME_PLACEHOLDER; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int { return WiredCapabilityCodes.ADDONS; }

        override public function buildInputs(manager:PresetManager, style:WiredStyle,
                                             builder:WiredUIBuilder)
        {
            this._name = manager.createPlaceholderNameSection(this.l("texts.placeholder_name"), "$");
            this._type = manager.createPlaceholderTypeSection("user");
            builder.addElements([this._name, this._type]);
        }

        override public function onEditStart(definition:Triggerable)
        {
            var text:Array<ASAny> = (cast definition.stringData.split("\t"));
            this._name.placeholderName = text.length > 0 ? ASCompat.toString(text[0]) : "";
            this._type.isShowMultiple = definition.intData.length > 0 && ASCompat.toInt(definition.intData[0]) == 1;
            this._type.delimiter = text.length > 1 ? ASCompat.toString(text[1]) : "";
        }

        override public function readIntParamsFromForm():Array<ASAny>
        {
            return [this._type.isShowMultiple ? 1 : 0];
        }
        override public function readStringParamFromForm():String
        {
            return this._type.isShowMultiple
                ? this._name.placeholderName + "\t" + this._type.delimiter : this._name.placeholderName;
        }

	public function new() { super(); }
    }

