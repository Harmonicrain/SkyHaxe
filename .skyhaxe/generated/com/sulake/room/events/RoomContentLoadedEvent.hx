package com.sulake.room.events
;
    import flash.events.Event;

     class RoomContentLoadedEvent extends Event 
    {
        public static inline final RCLE_SUCCESS= "RCLE_SUCCESS";
        public static inline final RCLE_FAILURE= "RCLE_FAILURE";
        public static inline final RCLE_CANCEL= "RCLE_CANCEL";

        var _contentType:String;

        public function new(k:String, _arg_2:String, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_3, _arg_4);
            this._contentType = _arg_2;
        }

        public var contentType(get,never):String;
public function  get_contentType():String
        {
            return this._contentType;
        }
    }

