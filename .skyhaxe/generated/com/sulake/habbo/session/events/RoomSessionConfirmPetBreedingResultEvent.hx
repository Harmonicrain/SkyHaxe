package com.sulake.habbo.session.events
;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionConfirmPetBreedingResultEvent extends RoomSessionEvent 
    {
        public static inline final RSPFUE_CONFIRM_PET_BREEDING_RESULT= "RSPFUE_CONFIRM_PET_BREEDING_RESULT";

        var _breedingNestStuffId:Int = 0;
        var _result:Int = 0;

        public function new(k:IRoomSession, _arg_2:Int, _arg_3:Int, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(RSPFUE_CONFIRM_PET_BREEDING_RESULT, k, _arg_4, _arg_5);
            this._breedingNestStuffId = _arg_2;
            this._result = _arg_3;
        }

        public var breedingNestStuffId(get,never):Int;
public function  get_breedingNestStuffId():Int
        {
            return this._breedingNestStuffId;
        }

        public var result(get,never):Int;
public function  get_result():Int
        {
            return this._result;
        }
    }

