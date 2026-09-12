package com.sulake.habbo.roomevents.userdefinedroomevents.conditions
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.UserDefinedRoomEventsCtrl;

     class ActorOnFurni extends WiredCondition 
    {
        override public function  get_code():Int
        {
            return ConditionCodes.TRIGGERER_IS_ON_FURNI;
        }

        override public function  get_negativeCode():Int
        {
            return ConditionCodes.NOT_ACTOR_ON_FURNI;
        }

        override public function  get_requiresFurni():Int
        {
            return UserDefinedRoomEventsCtrl._Str_4873;
        }
public function new(){	super();
}
    }

