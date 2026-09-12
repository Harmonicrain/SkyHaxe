package com.sulake.habbo.roomevents.wired_setup.conditions
;
     class FurniPickingConditionElement extends SimpleConditionElement
    {
        public function new(_arg_1:Int, _arg_2:Int = -1)
        {
            super(_arg_1, _arg_2);
        }

        override public function  get_requiresFurniSelection():Bool
        {
            return true;
        }
    }

