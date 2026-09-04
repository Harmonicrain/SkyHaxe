package com.sulake.habbo.room.messages
;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

     class RoomObjectVisibilityUpdateMessage extends RoomObjectUpdateMessage 
    {
        public static inline final ROVUM_ENABLED= "ROVUM_ENABLED";
        public static inline final ROVUM_DISABLED= "ROVUM_DISABLED";

        var _type:String;

        public function new(k:String)
        {
            super(null, null);
            this._type = k;
        }

        public var type(get,never):String;
function  get_type():String
        {
            return this._type;
        }
    }

