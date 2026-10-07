package com.sulake.habbo.ui.widget.messages
;
    import com.sulake.habbo.ui.widget.events.RoomWidgetUpdateEvent;

     class RoomWidgetInventoryUpdatedMessage extends RoomWidgetUpdateEvent 
    {
        public static inline final RWIUM_INVENTORY_UPDATED= "RWIUM_INVENTORY_UPDATED";

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(k, _arg_2, _arg_3);
        }
    }

