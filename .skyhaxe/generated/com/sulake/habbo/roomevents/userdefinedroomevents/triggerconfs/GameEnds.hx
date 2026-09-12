package com.sulake.habbo.roomevents.userdefinedroomevents.triggerconfs
;
     class GameEnds extends WiredTrigger 
    {


        override public function  get_code():Int
        {
            return WiredTriggerType.GAME_ENDS;
        }
public function new(){	super();
}
    }

