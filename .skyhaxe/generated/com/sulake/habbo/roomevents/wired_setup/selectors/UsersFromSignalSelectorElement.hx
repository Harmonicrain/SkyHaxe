package com.sulake.habbo.roomevents.wired_setup.selectors
;
    import com.sulake.habbo.roomevents.WiredCapabilityCodes;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;

    /** July AIR selector 10. Filter and invert remain selector-level advanced options. */
     class UsersFromSignalSelectorElement extends DefaultElement
    {
        override public function  get_code():Int
        {
            return SelectorCodes.USERS_FROM_SIGNAL;
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function  get_requiredCapability():Int
        {
            return WiredCapabilityCodes.SIGNALS;
        }

	public function new() { super(); }
    }

