package com.sulake.habbo.catalog.viewer.widgets.events
;
    import flash.events.Event;

     class CatalogWidgetRoomChangedEvent extends Event 
    {
        public function new(k:Bool=false, _arg_2:Bool=false)
        {
            super(CatalogWidgetEvent.ROOM_CHANGED, k, _arg_2);
        }
    }

