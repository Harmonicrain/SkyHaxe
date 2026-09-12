package com.sulake.habbo.session.events
;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionPetBreedingEvent extends RoomSessionEvent 
    {
        public static inline final RSPFUE_PET_BREEDING= "RSPFUE_PET_BREEDING";

        var _state:Int = 0;
        var _ownPetId:Int = 0;
        var _otherPetId:Int = 0;

        public function new(k:IRoomSession, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Bool=false, _arg_6:Bool=false)
        {
            super(RSPFUE_PET_BREEDING, k, _arg_5, _arg_6);
            this._state = _arg_2;
            this._ownPetId = _arg_3;
            this._otherPetId = _arg_4;
        }

        public var state(get,never):Int;
public function  get_state():Int
        {
            return this._state;
        }

        public var ownPetId(get,never):Int;
public function  get_ownPetId():Int
        {
            return this._ownPetId;
        }

        public var otherPetId(get,never):Int;
public function  get_otherPetId():Int
        {
            return this._otherPetId;
        }
    }

