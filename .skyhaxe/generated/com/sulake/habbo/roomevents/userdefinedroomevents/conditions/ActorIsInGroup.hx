package com.sulake.habbo.roomevents.userdefinedroomevents.conditions
;
     class ActorIsInGroup extends WiredCondition 
    {
        override public function  get_code():Int
        {
            return ConditionCodes.ACTOR_IS_GROUP_MEMBER;
        }

        override public function  get_negativeCode():Int
        {
            return ConditionCodes.NOT_ACTOR_IN_GROUP;
        }
public function new(){	super();
}
    }

