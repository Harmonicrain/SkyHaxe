package com.sulake.habbo.room.events
;
    import com.sulake.room.object.IRoomObject;

     class RoomObjectPlaySoundIdEvent extends RoomObjectFurnitureActionEvent 
    {
        public static inline final ROPSIE_PLAY_SOUND= "ROPSIE_PLAY_SOUND";
        public static inline final ROPSIE_PLAY_SOUND_AT_PITCH= "ROPSIE_PLAY_SOUND_AT_PITCH";

        var _soundId:String;
        var _pitch:Float = Math.NaN;

        public function new(k:String, _arg_2:IRoomObject, _arg_3:String, _arg_4:Float=1, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(k, _arg_2, _arg_5, _arg_6);
            this._soundId = _arg_3;
            this._pitch = _arg_4;
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

