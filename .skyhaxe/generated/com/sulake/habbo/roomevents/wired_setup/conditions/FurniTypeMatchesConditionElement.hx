package com.sulake.habbo.roomevents.wired_setup.conditions
;
    import com.sulake.habbo.roomevents.userdefinedroomevents.conditions.ConditionCodes;

     class FurniTypeMatchesConditionElement extends FurniPickingConditionElement
    {
        public function new()
        {
            super(ConditionCodes.STUFF_TYPE_MATCHES, ConditionCodes.NOT_FURNI_IS_OF_TYPE);
        }

        override public function furniSelectionTitle(index:Int):String
        {
            return "wiredfurni.params.sources.furni.title.match." + Std.string(index);
        }

        override public function advancedAlwaysVisible():Bool { return true; }
    }

