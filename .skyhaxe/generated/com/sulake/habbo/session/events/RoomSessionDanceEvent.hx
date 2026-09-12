package com.sulake.habbo.session.events
;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionDanceEvent extends RoomSessionEvent 
    {
        public static inline final RSDE_DANCE= "RSDE_DANCE";

        var _userId:Int = 0;
        var _danceStyle:Int = 0;

        public function new(k:IRoomSession, _arg_2:Int, _arg_3:Int, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(RSDE_DANCE, k, _arg_4, _arg_5);
            this._userId = _arg_2;
            this._danceStyle = _arg_3;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var _Str_8263(get,never):Int;
public function  get__Str_8263():Int
        {
            return this._danceStyle;
        }
    }

