package com.sulake.habbo.room.events
;
     class RoomZoomEvent extends RoomEngineEvent 
    {
        public static inline final ROOM_ZOOM= "REE_ROOM_ZOOM";

        var _level:Float = 1;
        var _forceFlip:Bool = false;

        public function new(roomId:Int, level:Float, _arg_3:ASAny=false, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(ROOM_ZOOM, roomId, _arg_4, _arg_5);
            this._level = level;
            this._forceFlip = _arg_3;
        }

        public var level(get,never):Float;
public function  get_level():Float
        {
            return this._level;
        }

        public var isFlipForced(get,never):Bool;
public function  get_isFlipForced():Bool
        {
            return this._forceFlip;
        }
    }

