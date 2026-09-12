package com.sulake.habbo.roomevents.wired_setup.addons
;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;

    /** July addon 6: parameterless movement-animation modifier. */
     class NoMoveAnimationAddonElement extends DefaultElement
    {
        override public function  get_code():Int { return AddonCodes.NO_MOVE_ANIMATION; }
        override public function  get_inputMode():Int { return DefaultElement.INPUTS_TYPE_UI_BUILDER; }
        override public function  get_requiredCapability():Int { return WiredCapabilityCodes.ADDONS; }

	public function new() { super(); }
    }

