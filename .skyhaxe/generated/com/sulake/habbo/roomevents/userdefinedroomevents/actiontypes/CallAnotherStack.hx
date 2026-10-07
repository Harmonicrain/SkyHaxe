package com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.UserDefinedRoomEventsCtrl;

     class CallAnotherStack extends DefaultActionType 
    {
        override public function  get_code():Int
        {
            return ActionTypeCodes.CALL_ANOTHER_STACK;
        }

        override public function  get_requiresFurni():Int
        {
            return UserDefinedRoomEventsCtrl._Str_4873;
        }
public function new(){	super();
}
    }

