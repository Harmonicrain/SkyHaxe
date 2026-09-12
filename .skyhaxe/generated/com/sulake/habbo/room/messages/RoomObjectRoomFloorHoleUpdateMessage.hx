package com.sulake.habbo.room.messages
;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

     class RoomObjectRoomFloorHoleUpdateMessage extends RoomObjectUpdateMessage 
    {
        public static inline final RORPFHUM_ADD= "RORPFHUM_ADD";
        public static inline final RORPFHUM_REMOVE= "RORPFHUM_REMOVE";

        var _type:String = "";
        var _id:Int = 0;
        var _x:Int = 0;
        var _y:Int = 0;
        var _width:Int = 0;
        var _height:Int = 0;
        var _invert:Bool = false;

        public function new(k:String, _arg_2:Int, _arg_3:Int=0, _arg_4:Int=0, _arg_5:Int=0, _arg_6:Int=0, _arg_7:Bool=false)
        {
            super(null, null);
            this._type = k;
            this._id = _arg_2;
            this._x = _arg_3;
            this._y = _arg_4;
            this._width = _arg_5;
            this._height = _arg_6;
            this._invert = _arg_7;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return this._type;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var x(get,never):Int;
public function  get_x():Int
        {
            return this._x;
        }

        public var y(get,never):Int;
public function  get_y():Int
        {
            return this._y;
        }

        public var width(get,never):Int;
public function  get_width():Int
        {
            return this._width;
        }

        public var height(get,never):Int;
public function  get_height():Int
        {
            return this._height;
        }

        public var invert(get,never):Bool;
public function  get_invert():Bool
        {
            return this._invert;
        }
    }

