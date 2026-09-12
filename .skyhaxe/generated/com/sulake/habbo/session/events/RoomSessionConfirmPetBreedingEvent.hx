package com.sulake.habbo.session.events
;
    import com.sulake.habbo.communication.messages.incoming.room.pets.BreedingPetInfo;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionConfirmPetBreedingEvent extends RoomSessionEvent 
    {
        public static inline final RSPFUE_CONFIRM_PET_BREEDING= "RSPFUE_CONFIRM_PET_BREEDING";

        var _nestId:Int = 0;
        var _pet1:BreedingPetInfo;
        var _pet2:BreedingPetInfo;
        var _rarityCategories:Array<ASAny>;
        var _resultPetTypeId:Int = 0;

        public function new(k:IRoomSession, _arg_2:Int, _arg_3:BreedingPetInfo, _arg_4:BreedingPetInfo, _arg_5:Array<ASAny>, _arg_6:Int, _arg_7:Bool=false, _arg_8:Bool=false)
        {
            super(RSPFUE_CONFIRM_PET_BREEDING, k, _arg_7, _arg_8);
            this._nestId = _arg_2;
            this._pet1 = _arg_3;
            this._pet2 = _arg_4;
            this._rarityCategories = _arg_5;
            this._resultPetTypeId = _arg_6;
        }

        public var rarityCategories(get,never):Array<ASAny>;
public function  get_rarityCategories():Array<ASAny>
        {
            return this._rarityCategories;
        }

        public var nestId(get,never):Int;
public function  get_nestId():Int
        {
            return this._nestId;
        }

        public var pet1(get,never):BreedingPetInfo;
public function  get_pet1():BreedingPetInfo
        {
            return this._pet1;
        }

        public var pet2(get,never):BreedingPetInfo;
public function  get_pet2():BreedingPetInfo
        {
            return this._pet2;
        }

        public var resultPetTypeId(get,never):Int;
public function  get_resultPetTypeId():Int
        {
            return this._resultPetTypeId;
        }
    }

