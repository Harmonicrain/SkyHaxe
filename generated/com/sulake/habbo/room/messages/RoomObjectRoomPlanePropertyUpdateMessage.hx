package com.sulake.habbo.room.messages
;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

     class RoomObjectRoomPlanePropertyUpdateMessage extends RoomObjectUpdateMessage 
    {
        public static inline final RORPPUM_WALL_THICKNESS= "RORPPUM_WALL_THICKNESS";
        public static inline final RORPVUM_FLOOR_THICKNESS= "RORPVUM_FLOOR_THICKNESS";

        var _type:String = "";
        var _value:Float = 0;

        public function new(k:String, _arg_2:Float)
        {
            super(null, null);
            this._type = k;
            this._value = _arg_2;
        }

        public var type(get,never):String;
function  get_type():String
        {
            return this._type;
        }

        public var value(get,never):Float;
function  get_value():Float
        {
            return this._value;
        }
    }

