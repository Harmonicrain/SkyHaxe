package com.sulake.habbo.room.messages
;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

     class RoomObjectRoomColorUpdateMessage extends RoomObjectUpdateMessage 
    {
        public static inline final RORCUM_BACKGROUND_COLOR= "RORCUM_BACKGROUND_COLOR";

        var _type:String = "";
        var _color:UInt = 0;
        var _light:Int = 0;
        var _bgOnly:Bool = true;

        public function new(k:String, _arg_2:UInt, _arg_3:Int, _arg_4:Bool)
        {
            super(null, null);
            this._type = k;
            this._color = _arg_2;
            this._light = _arg_3;
            this._bgOnly = _arg_4;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return this._type;
        }

        public var color(get,never):UInt;
public function  get_color():UInt
        {
            return this._color;
        }

        public var brightness(get,never):UInt;
public function  get_brightness():UInt
        {
            return this._light;
        }

        public var bgOnly(get,never):Bool;
public function  get_bgOnly():Bool
        {
            return this._bgOnly;
        }
    }

