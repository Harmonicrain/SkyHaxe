package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.parser.inventory.pets.Pet;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PetRespectNotificationParser implements IMessageParser
    {
        public static inline final PET_TYPE_MONSTERPLANT= 16;

        var _respect:Int = 0;
        var _petOwnerId:Int = 0;
        var _petData:Pet;


        public function flush():Bool
        {
            this._petData = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._respect = k.readInteger();
            this._petOwnerId = k.readInteger();
            this._petData = new Pet(k);
            return true;
        }

        public var petOwnerId(get,never):Int;
function  get_petOwnerId():Int
        {
            return this._petOwnerId;
        }

        public var respect(get,never):Int;
function  get_respect():Int
        {
            return this._respect;
        }

        public var petData(get,never):Pet;
function  get_petData():Pet
        {
            return this._petData;
        }

        public function isTreat():Bool
        {
            return this._petData.typeId == PET_TYPE_MONSTERPLANT;
        }

	public function new() {}
    }

