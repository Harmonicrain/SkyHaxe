package com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes
;
     class Reset extends DefaultActionType 
    {
        override public function  get_code():Int
        {
            return ActionTypeCodes.RESET;
        }
public function new(){	super();
}
    }

