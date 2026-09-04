package com.sulake.habbo.room.events
;
    import com.sulake.room.object.IRoomObject;

     class RoomObjectSamplePlaybackEvent extends RoomObjectFurnitureActionEvent 
    {
        public static inline final ROPSPE_ROOM_OBJECT_INITIALIZED= "ROPSPE_ROOM_OBJECT_INITIALIZED";
        public static inline final ROPSPE_ROOM_OBJECT_DISPOSED= "ROPSPE_ROOM_OBJECT_DISPOSED";
        public static inline final ROPSPE_PLAY_SAMPLE= "ROPSPE_PLAY_SAMPLE";
        public static inline final ROPSPE_CHANGE_PITCH= "ROPSPE_CHANGE_PITCH";

        var _sampleId:Int = 0;
        var _pitch:Float = Math.NaN;

        public function new(k:String, _arg_2:IRoomObject, _arg_3:Int, _arg_4:Float=1, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(k, _arg_2, _arg_5, _arg_6);
            this._sampleId = _arg_3;
            this._pitch = _arg_4;
        }

        public var _Str_6992(get,never):Int;
function  get__Str_6992():Int
        {
            return this._sampleId;
        }

        public var pitch(get,never):Float;
function  get_pitch():Float
        {
            return this._pitch;
        }
    }

