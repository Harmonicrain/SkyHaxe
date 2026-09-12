package com.sulake.habbo.roomevents.wired_setup.triggerconfs
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs.WiredTriggerType;

     class BotReachedAvatarElement extends BotReachedStuffElement
    {
        public function new()
        {
            super();
        }

        override public function  get_code():Int
        {
            return WiredTriggerType.BOT_REACHED_AVATAR;
        }
    }

