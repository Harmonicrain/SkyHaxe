package com.sulake.habbo.roomevents.wired_setup.triggerconfs
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.WiredTriggerType;

     class AvatarWalksOffFurniElement extends SimpleTriggerElement
    {
        public function new()
        {
            super(WiredTriggerType.AVATAR_WALKS_OFF_FURNI);
        }

        override public function  get_requiresFurniSelection():Bool
        {
            return true;
        }
    }

