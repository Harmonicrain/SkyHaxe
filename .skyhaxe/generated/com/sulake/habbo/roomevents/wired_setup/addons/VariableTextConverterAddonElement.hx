package com.sulake.habbo.roomevents.wired_setup.addons
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.Triggerable;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.WiredUIBuilder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextAreaParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextAreaPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;
    /** July addon 1000: connect numeric variable values to text. */
     class VariableTextConverterAddonElement extends DefaultElement
    {
        var _text:TextAreaPreset;
        override public function  get_code():Int { return AddonCodes.VARIABLE_TEXT_CONVERTER; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int { return WiredCapabilityCodes.ADDONS | WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC; }
        override public function buildInputs(m:PresetManager,s:WiredStyle,b:WiredUIBuilder)
        {
            this._text=m.createTextArea(new TextAreaParam(100,-1,30,-1,1000,"",this.l("variables.connect_text.caption")));
            b.addElements([m.createSection(this.l("variables.connect_text.title"),this._text)]);
        }
        override public function onEditStart(d:Triggerable) { this._text.text=d.stringData; }
        override public function readStringParamFromForm():String { return this._text.text; }

	public function new() { super(); }
    }

