package com.sulake.habbo.roomevents.wired_setup.addons
;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;

    /** July addon 12: sort/filter a furniture-variable selector result. */
     class FurniVariableFilterAddonElement extends VariableFilterAddonElement
    {
        override public function  get_code():Int { return AddonCodes.FURNI_VARIABLE_FILTER; }
        override function  get_variableTarget():Int { return WiredInputSourcePicker.FURNI_SOURCE; }

	public function new() { super(); }
    }

