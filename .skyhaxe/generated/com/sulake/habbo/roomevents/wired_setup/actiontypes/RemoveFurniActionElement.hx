package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

     class RemoveFurniActionElement extends DefaultElement
    {
        override public function  get_code():Int { return ActionTypeCodes.REMOVE_FURNI; }

        override public function advancedAlwaysVisible():Bool { return true; }

	public function new() { super(); }
    }

