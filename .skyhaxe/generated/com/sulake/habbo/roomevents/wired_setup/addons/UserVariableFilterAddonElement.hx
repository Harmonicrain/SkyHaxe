package com.sulake.habbo.roomevents.wired_setup.addons
;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;

    /** July addon 13: sort/filter a user-variable selector result. */
     class UserVariableFilterAddonElement extends VariableFilterAddonElement
    {
        override public function  get_code():Int { return AddonCodes.USER_VARIABLE_FILTER; }
        override function  get_variableTarget():Int { return WiredInputSourcePicker.USER_SOURCE; }

	public function new() { super(); }
    }

