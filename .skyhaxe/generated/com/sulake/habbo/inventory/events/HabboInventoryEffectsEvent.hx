package com.sulake.habbo.inventory.events
;
    import flash.events.Event;

     class HabboInventoryEffectsEvent extends Event 
    {
        public static inline final HIEE_EFFECTS_CHANGED= "HIEE_EFFECTS_CHANGED";

        var _effects:Array<ASAny>;

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(k, _arg_2, _arg_3);
        }
    }

