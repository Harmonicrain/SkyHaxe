package com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.UserDefinedRoomEventsCtrl;

     class Teleport extends DefaultActionType 
    {
        override public function  get_code():Int
        {
            return ActionTypeCodes.TELEPORT;
        }

        override public function  get_requiresFurni():Int
        {
            return UserDefinedRoomEventsCtrl._Str_4991;
        }
public function new(){	super();
}
    }

