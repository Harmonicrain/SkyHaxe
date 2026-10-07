package com.sulake.habbo.session.events
;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionNestBreedingSuccessEvent extends RoomSessionEvent 
    {
        public static inline final RSPFUE_NEST_BREEDING_SUCCESS= "RSPFUE_NEST_BREEDING_SUCCESS";

        var _rarityCategory:Int = 0;
        var _petId:Int = 0;

        public function new(k:IRoomSession, _arg_2:Int, _arg_3:Int, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(RSPFUE_NEST_BREEDING_SUCCESS, k, _arg_4, _arg_5);
            this._petId = _arg_2;
            this._rarityCategory = _arg_3;
        }

        public var rarityCategory(get,never):Int;
public function  get_rarityCategory():Int
        {
            return this._rarityCategory;
        }

        public var petId(get,never):Int;
public function  get_petId():Int
        {
            return this._petId;
        }
    }

