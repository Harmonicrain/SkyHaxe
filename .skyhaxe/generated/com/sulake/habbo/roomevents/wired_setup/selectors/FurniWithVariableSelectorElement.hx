package com.sulake.habbo.roomevents.wired_setup.selectors
;
    import com.sulake.habbo.roomevents.wired_setup.inputsources.WiredInputSourcePicker;

    /** July AIR selector 17: choose furni whose selected variable matches a value. */
     class FurniWithVariableSelectorElement extends VariableSelectorElement
    {
        override public function  get_code():Int { return SelectorCodes.FURNI_WITH_VARIABLE; }
        override function  get_variableSource():Int { return WiredInputSourcePicker.FURNI_SOURCE; }

	public function new() { super(); }
    }

