package com.sulake.habbo.session.events
;
    import com.sulake.habbo.communication.messages.incoming.room.pets.PetBreedingResultData;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionPetBreedingResultEvent extends RoomSessionEvent 
    {
        public static inline final RSPFUE_PET_BREEDING_RESULT= "RSPFUE_PET_BREEDING_RESULT";

        var _resultData:PetBreedingResultData;
        var _otherResultData:PetBreedingResultData;

        public function new(k:IRoomSession, _arg_2:PetBreedingResultData, _arg_3:PetBreedingResultData, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(RSPFUE_PET_BREEDING_RESULT, k, _arg_4, _arg_5);
            this._resultData = _arg_2;
            this._otherResultData = _arg_3;
        }

        public var _Str_3713(get,never):PetBreedingResultData;
public function  get__Str_3713():PetBreedingResultData
        {
            return this._resultData;
        }

        public var _Str_5840(get,never):PetBreedingResultData;
public function  get__Str_5840():PetBreedingResultData
        {
            return this._otherResultData;
        }
    }

