package com.sulake.habbo.roomevents.wired_setup.addons
;
    /** July addon 11: filter the current user selector result. */
     class UserSelectorFilterAddonElement extends SelectorFilterAddonElement
    {
        override public function  get_code():Int { return AddonCodes.USER_SELECTOR_FILTER; }

	public function new() { super(); }
    }

