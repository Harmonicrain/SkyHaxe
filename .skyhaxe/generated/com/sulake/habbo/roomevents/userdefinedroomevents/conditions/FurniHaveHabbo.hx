package com.sulake.habbo.roomevents.userdefinedroomevents.conditions
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.UserDefinedRoomEventsCtrl;

     class FurniHaveHabbo extends WiredCondition 
    {
        override public function  get_code():Int
        {
            return ConditionCodes.FURNIS_HAVE_AVATARS;
        }

        override public function  get_negativeCode():Int
        {
            return ConditionCodes.FURNI_NOT_HAVE_HABBO;
        }

        override public function  get_requiresFurni():Int
        {
            return UserDefinedRoomEventsCtrl._Str_4873;
        }
public function new(){	super();
}
    }

