package com.sulake.habbo.room.events
;
     class RoomEngineObjectPlaySoundEvent extends RoomEngineObjectEvent
    {
        public static inline final PLAY_SOUND= "REPSE_PLAY_SOUND";
        public static inline final PLAY_SOUND_AT_PITCH= "REPSE_PLAY_SOUND_AT_PITCH";

        var _soundId:String;
        var _pitch:Float = Math.NaN;

        public function new(k:String, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:String, _arg_6:Float=1, _arg_7:Bool=false, _arg_8:Bool=false)
        {
            super(k, _arg_2, _arg_3, _arg_4);
            this._soundId = _arg_5;
            this._pitch = _arg_6;
        }

        public var soundId(get,never):String;
public function  get_soundId():String
        {
            return this._soundId;
        }

        public var pitch(get,never):Float;
public function  get_pitch():Float
        {
            return this._pitch;
        }
    }

