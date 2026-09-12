package com.sulake.habbo.roomevents.wired_setup.triggerconfs
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.WiredTriggerType;

     class ToggleFurniElement extends SimpleTriggerElement
    {
        public function new()
        {
            super(WiredTriggerType.TOGGLE_FURNI);
        }

        override public function  get_requiresFurniSelection():Bool
        {
            return true;
        }
    }

