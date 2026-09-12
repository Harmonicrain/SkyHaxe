package com.sulake.habbo.roomevents.wired_setup.selectors
;
    import com.sulake.habbo.roomevents.wired_setup.conditions.ActorIsInGroupConditionElement;

     class UsersInGroupSelectorElement extends ActorIsInGroupConditionElement
    {
        override public function  get_code():Int { return SelectorCodes.USERS_IN_GROUP; }
        override public function  get_negativeCode():Int { return -1; }

	public function new() { super(); }
    }

