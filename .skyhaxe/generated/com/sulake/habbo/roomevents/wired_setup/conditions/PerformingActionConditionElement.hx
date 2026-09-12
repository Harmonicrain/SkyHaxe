package com.sulake.habbo.roomevents.wired_setup.conditions
;
    import com.sulake.habbo.roomevents.wired_setup.common.UserActionElement;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

     class PerformingActionConditionElement extends UserActionElement
    {
        public function new()
        {
            super(ConditionCodes.PERFORMING_ACTION, ConditionCodes.NOT_PERFORMING_ACTION);
        }
    }

