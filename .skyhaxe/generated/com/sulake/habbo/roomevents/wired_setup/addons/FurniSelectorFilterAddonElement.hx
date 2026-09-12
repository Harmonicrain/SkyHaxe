package com.sulake.habbo.roomevents.wired_setup.addons
;
    /** July addon 10: filter the current furniture selector result. */
     class FurniSelectorFilterAddonElement extends SelectorFilterAddonElement
    {
        override public function  get_code():Int { return AddonCodes.FURNI_SELECTOR_FILTER; }

	public function new() { super(); }
    }

