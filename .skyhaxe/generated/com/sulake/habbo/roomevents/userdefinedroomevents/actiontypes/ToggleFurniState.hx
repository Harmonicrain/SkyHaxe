package com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.UserDefinedRoomEventsCtrl;

     class ToggleFurniState extends DefaultActionType 
    {
        override public function  get_code():Int
        {
            return ActionTypeCodes.TOGGLE_FURNI_STATE;
        }

        override public function  get_requiresFurni():Int
        {
            return UserDefinedRoomEventsCtrl._Str_5430;
        }
public function new(){	super();
}
    }

