package com.sulake.habbo.room.events
;
     class RoomEngineObjectSamplePlaybackEvent extends RoomEngineObjectEvent 
    {
        public static inline final REOSPE_ROOM_OBJECT_INITIALIZED= "REOSPE_ROOM_OBJECT_INITIALIZED";
        public static inline final REOSPE_ROOM_OBJECT_DISPOSED= "REOSPE_ROOM_OBJECT_DISPOSED";
        public static inline final REOSPE_PLAY_SAMPLE= "REOSPE_PLAY_SAMPLE";
        public static inline final REOSPE_CHANGE_PITCH= "REOSPE_CHANGE_PITCH";

        var _sampleId:Int = 0;
        var _pitch:Float = Math.NaN;

        public function new(k:String, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int, _arg_6:Float=1, _arg_7:Bool=false, _arg_8:Bool=false)
        {
            super(k, _arg_2, _arg_3, _arg_4);
            this._sampleId = _arg_5;
            this._pitch = _arg_6;
        }

        public var _Str_6992(get,never):Int;
public function  get__Str_6992():Int
        {
            return this._sampleId;
        }

        public var pitch(get,never):Float;
public function  get_pitch():Float
        {
            return this._pitch;
        }
    }

