package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetDimmerChangeStateMessage extends RoomWidgetMessage 
    {
        public static inline final RWCDSM_CHANGE_STATE= "RWCDSM_CHANGE_STATE";

        public function new()
        {
            super(RoomWidgetDimmerChangeStateMessage.RWCDSM_CHANGE_STATE);
        }
    }

