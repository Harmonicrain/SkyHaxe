package com.sulake.habbo.roomevents.wired_setup.selectors
;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;

    /** July AIR selector 18: choose users whose selected variable matches a value. */
     class UsersWithVariableSelectorElement extends VariableSelectorElement
    {
        override public function  get_code():Int { return SelectorCodes.USERS_WITH_VARIABLE; }
        override function  get_variableSource():Int { return WiredInputSourcePicker.USER_SOURCE; }

	public function new() { super(); }
    }

