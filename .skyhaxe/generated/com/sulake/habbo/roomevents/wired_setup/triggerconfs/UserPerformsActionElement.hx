package com.sulake.habbo.roomevents.wired_setup.triggerconfs
;
    import com.sulake.habbo.roomevents.wired_setup.common.UserActionElement;
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.WiredTriggerType;

     class UserPerformsActionElement extends UserActionElement
    {
        public function new()
        {
            super(WiredTriggerType.USER_PERFORMS_ACTION);
        }
    }

