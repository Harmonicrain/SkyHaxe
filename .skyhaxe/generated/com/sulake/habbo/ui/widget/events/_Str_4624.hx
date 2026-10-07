package com.sulake.habbo.ui.widget.events
;
     class _Str_4624 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWPPBE_CONFIRM_PET_BREEDING_= "RWPPBE_CONFIRM_PET_BREEDING_";

        var _nestId:Int = 0;
        var _pet1:ConfirmPetBreedingPetData;
        var _pet2:ConfirmPetBreedingPetData;
        var _rarityCategories:Array<ASAny>;
        var _resultPetTypeId:Int = 0;

        public function new(k:Int, _arg_2:ConfirmPetBreedingPetData, _arg_3:ConfirmPetBreedingPetData, _arg_4:Array<ASAny>, _arg_5:Int, _arg_6:Bool=false, _arg_7:Bool=false)
        {
            super(RWPPBE_CONFIRM_PET_BREEDING_, _arg_6, _arg_7);
            this._nestId = k;
            this._pet1 = _arg_2;
            this._pet2 = _arg_3;
            this._rarityCategories = _arg_4;
            this._resultPetTypeId = _arg_5;
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

        public var pet1(get,never):ConfirmPetBreedingPetData;
public function  get_pet1():ConfirmPetBreedingPetData
        {
            return this._pet1;
        }

        public var pet2(get,never):ConfirmPetBreedingPetData;
public function  get_pet2():ConfirmPetBreedingPetData
        {
            return this._pet2;
        }

        public var resultPetTypeId(get,never):Int;
public function  get_resultPetTypeId():Int
        {
            return this._resultPetTypeId;
        }
    }

