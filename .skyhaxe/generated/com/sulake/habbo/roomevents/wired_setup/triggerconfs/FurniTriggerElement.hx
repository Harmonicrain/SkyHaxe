package com.sulake.habbo.roomevents.wired_setup.triggerconfs
;
     class FurniTriggerElement extends SimpleTriggerElement
    {
        public function new(_arg_1:Int)
        {
            super(_arg_1);
        }

        override public function  get_requiresFurniSelection():Bool
        {
            return true;
        }
    }

