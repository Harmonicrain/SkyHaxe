package com.sulake.habbo.room.messages
;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

     class RoomObjectRoomPlaneVisibilityUpdateMessage extends RoomObjectUpdateMessage 
    {
        public static inline final RORPVUM_WALL_VISIBILITY= "RORPVUM_WALL_VISIBILITY";
        public static inline final RORPVUM_FLOOR_VISIBILITY= "RORPVUM_FLOOR_VISIBILITY";

        var _type:String = "";
        var _visible:Bool = false;

        public function new(k:String, _arg_2:Bool)
        {
            super(null, null);
            this._type = k;
            this._visible = _arg_2;
        }

        public var type(get,never):String;
function  get_type():String
        {
            return this._type;
        }

        public var visible(get,never):Bool;
function  get_visible():Bool
        {
            return this._visible;
        }
    }

