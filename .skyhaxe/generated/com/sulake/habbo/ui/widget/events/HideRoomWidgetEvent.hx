package com.sulake.habbo.ui.widget.events
;
    import flash.events.Event;

     class HideRoomWidgetEvent extends Event
    {
        public static inline final HRWE_HIDE_ROOM_WIDGET= "hrwe_hide_room_widget";

        var _widgetType:String;

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(HRWE_HIDE_ROOM_WIDGET, _arg_2, _arg_3);
            this._widgetType = k;
        }

        public var widgetType(get,never):String;
public function  get_widgetType():String
        {
            return this._widgetType;
        }
    }

