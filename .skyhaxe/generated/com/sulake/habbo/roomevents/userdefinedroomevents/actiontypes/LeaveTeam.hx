package com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes
;
     class LeaveTeam extends DefaultActionType 
    {
        override public function  get_code():Int
        {
            return ActionTypeCodes.LEAVE_TEAM;
        }
public function new(){	super();
}
    }

