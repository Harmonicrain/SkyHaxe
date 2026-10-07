package com.sulake.habbo.session.events
;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionPetLevelUpdateEvent extends RoomSessionEvent 
    {
        public static inline final RSPLUE_PET_LEVEL_UPDATE= "RSPLUE_PET_LEVEL_UPDATE";

        var _petId:Int = 0;
        var _level:Int = 0;

        public function new(k:IRoomSession, _arg_2:Int, _arg_3:Int, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(RSPLUE_PET_LEVEL_UPDATE, k, _arg_4, _arg_5);
            this._petId = _arg_2;
            this._level = _arg_3;
        }

        public var petId(get,never):Int;
public function  get_petId():Int
        {
            return this._petId;
        }

        public var level(get,never):Int;
public function  get_level():Int
        {
            return this._level;
        }
    }

