package com.sulake.habbo.roomevents.wired_setup.selectors
;
     class UsersInNeighborhoodSelectorElement extends InNeighborhoodSelectorElement
    {
        override public function  get_code():Int
        {
            return SelectorCodes.USERS_IN_NEIGHBORHOOD;
        }

	public function new() { super(); }
    }

