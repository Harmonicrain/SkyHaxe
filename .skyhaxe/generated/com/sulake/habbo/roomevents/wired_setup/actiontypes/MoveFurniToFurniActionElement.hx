package com.sulake.habbo.roomevents.wired_setup.actiontypes
;
    import com.sulake.habbo.roomevents.wired_setup.DefaultElement;
    import com.sulake.habbo.roomevents.userdefinedroomevents.actiontypes.ActionTypeCodes;

     class MoveFurniToFurniActionElement extends DefaultElement
    {
        override public function  get_code():Int
        {
            return ActionTypeCodes.MOVE_FURNI_TO_FURNI;
        }

        override public function  get_inputMode():Int
        {
            return DefaultElement.INPUTS_TYPE_UI_BUILDER;
        }

        override public function  get_requiresFurniSelection():Bool
        {
            return true;
        }

        override public function  get_forceHidePickFurniInstructions():Bool
        {
            return true;
        }

        override public function inputSourcesAlwaysVisible():Bool
        {
            return true;
        }

        override public function furniSelectionTitle(_arg_1:Int):String
        {
            return "wiredfurni.params.sources.furni.title.mv." + Std.string(_arg_1);
        }

        override public function advancedAlwaysVisible():Bool
        {
            return true;
        }

        override public function readFurniIds2FromForm():Array<ASAny>
        {
            return this.roomEvents.wiredCtrl.getStuffIds2();
        }

	public function new() { super(); }
    }

