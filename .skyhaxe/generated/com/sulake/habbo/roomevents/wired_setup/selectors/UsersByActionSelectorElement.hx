package com.sulake.habbo.roomevents.wired_setup.selectors
;
    import com.sulake.habbo.roomevents.wired_setup.common.UserActionElement;

     class UsersByActionSelectorElement extends UserActionElement
    {
        public function new()
        {
            super(SelectorCodes.USERS_PERFORMING_ACTION);
        }
    }

