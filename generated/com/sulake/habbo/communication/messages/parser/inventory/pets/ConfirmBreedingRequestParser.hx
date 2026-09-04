package com.sulake.habbo.communication.messages.parser.inventory.pets
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.room.pets.BreedingPetInfo;
    import com.sulake.habbo.communication.messages.incoming.room.pets.RarityCategoryData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ConfirmBreedingRequestParser implements IMessageParser
    {
        var _nestId:Int = 0;
        var _pet1:BreedingPetInfo;
        var _pet2:BreedingPetInfo;
        var _rarityCategories:Array<ASAny>;
        var _Str_21973:Int = 0;


        public function flush():Bool
        {
            var k:RarityCategoryData;
            this._nestId = 0;
            if (this._pet1 != null)
            {
                this._pet1.dispose();
                this._pet1 = null;
            }
            if (this._pet2 != null)
            {
                this._pet2.dispose();
                this._pet2 = null;
            }
            for (_tmp_ in this._rarityCategories)
            {
k  = _tmp_;
                k.dispose();
            }
            this._rarityCategories = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._nestId = k.readInteger();
            this._pet1 = new BreedingPetInfo(k);
            this._pet2 = new BreedingPetInfo(k);
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._rarityCategories.push(new RarityCategoryData(k));
                _local_3++;
            }
            this._Str_21973 = k.readInteger();
            return true;
        }

        public var nestId(get,never):Int;
function  get_nestId():Int
        {
            return this._nestId;
        }

        public var pet1(get,never):BreedingPetInfo;
function  get_pet1():BreedingPetInfo
        {
            return this._pet1;
        }

        public var pet2(get,never):BreedingPetInfo;
function  get_pet2():BreedingPetInfo
        {
            return this._pet2;
        }

        public var rarityCategories(get,never):Array<ASAny>;
function  get_rarityCategories():Array<ASAny>
        {
            return this._rarityCategories;
        }

        public var _Str_24905(get,never):Int;
function  get__Str_24905():Int
        {
            return this._Str_21973;
        }

	public function new() {}
    }

