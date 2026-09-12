package com.sulake.habbo.roomevents.wired_setup.selectors
;
    import com.sulake.habbo.roomevents.wired_setup.conditions.ActorHasHandItemConditionElement;

     class UsersWithHanditemSelectorElement extends ActorHasHandItemConditionElement
    {
        override public function  get_code():Int { return SelectorCodes.USERS_WITH_HANDITEM; }

	public function new() { super(); }
    }

