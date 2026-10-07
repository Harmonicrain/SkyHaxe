package com.sulake.habbo.room.messages
;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

     class RoomObjectRoomUpdateMessage extends RoomObjectUpdateMessage 
    {
        public static inline final RORUM_ROOM_WALL_UPDATE= "RORUM_ROOM_WALL_UPDATE";
        public static inline final RORUM_ROOM_FLOOR_UPDATE= "RORUM_ROOM_FLOOR_UPDATE";
        public static inline final RORUM_ROOM_LANDSCAPE_UPDATE= "RORUM_ROOM_LANDSCAPE_UPDATE";

        var _type:String = "";
        var _value:String = "";

        public function new(k:String, _arg_2:String)
        {
            super(null, null);
            this._type = k;
            this._value = _arg_2;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return this._type;
        }

        public var value(get,never):String;
public function  get_value():String
        {
            return this._value;
        }
    }

