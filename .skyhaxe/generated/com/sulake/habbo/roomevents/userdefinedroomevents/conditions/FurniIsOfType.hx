package com.sulake.habbo.roomevents.userdefinedroomevents.conditions
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.UserDefinedRoomEventsCtrl;

     class FurniIsOfType extends WiredCondition 
    {
        override public function  get_code():Int
        {
            return ConditionCodes.STUFF_TYPE_MATCHES;
        }

        override public function  get_negativeCode():Int
        {
            return ConditionCodes.NOT_FURNI_IS_OF_TYPE;
        }

        override public function  get_requiresFurni():Int
        {
            return UserDefinedRoomEventsCtrl._Str_4991;
        }
public function new(){	super();
}
    }

