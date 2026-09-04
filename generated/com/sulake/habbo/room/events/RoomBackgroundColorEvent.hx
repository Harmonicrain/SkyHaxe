package com.sulake.habbo.room.events
;
     class RoomBackgroundColorEvent extends RoomEngineEvent 
    {
        public static inline final ROOM_COLOR= "REE_ROOM_COLOR";

        var _color:UInt = 0;
        var _Str_21672:UInt = 0;
        var _Str_6930:Bool = false;

        public function new(roomId:Int, color:UInt, _arg_3:UInt, _arg_4:Bool, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(ROOM_COLOR, roomId, _arg_5, _arg_6);
            this._color = color;
            this._Str_21672 = _arg_3;
            this._Str_6930 = _arg_4;
        }

        public var color(get,never):UInt;
function  get_color():UInt
        {
            return this._color;
        }

        public var brightness(get,never):UInt;
function  get_brightness():UInt
        {
            return this._Str_21672;
        }

        public var bgOnly(get,never):Bool;
function  get_bgOnly():Bool
        {
            return this._Str_6930;
        }
    }

