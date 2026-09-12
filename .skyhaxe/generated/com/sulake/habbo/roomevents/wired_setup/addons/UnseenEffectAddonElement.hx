package com.sulake.habbo.roomevents.wired_setup.addons
;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;

    /** July addon 2: parameterless effect-history modifier. */
     class UnseenEffectAddonElement extends DefaultElement
    {
        override public function  get_code():Int { return AddonCodes.UNSEEN_EFFECT; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int { return WiredCapabilityCodes.ADDONS; }

	public function new() { super(); }
    }

