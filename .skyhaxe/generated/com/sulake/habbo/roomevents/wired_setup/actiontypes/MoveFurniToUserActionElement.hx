package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

     class MoveFurniToUserActionElement extends FurniPickingActionElement
    {
        public function new()
        {
            super(ActionTypeCodes.MOVE_FURNI_TO_USER);
        }

        override public function furniSelectionTitle(index:Int):String
        {
            return "wiredfurni.params.sources.furni.title.mv.0";
        }

        override public function userSelectionTitle(index:Int):String
        {
            return "wiredfurni.params.sources.furni.title.mv_user";
        }

        override public function advancedAlwaysVisible():Bool { return true; }
    }

