package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
     class FurniPickingActionElement extends SimpleActionElement
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

