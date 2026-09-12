package com.sulake.habbo.communication.messages.parser.inventory.pets
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PetAddedToInventoryParser implements IMessageParser
    {
        var _pet:Pet;
        var _Str_12302:Bool = false;


        public function flush():Bool
        {
            this._pet = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._pet = new Pet(k);
            this._Str_12302 = k.readBoolean();
            return true;
        }

        public var pet(get,never):Pet;
public function  get_pet():Pet
        {
            return this._pet;
        }

        public function _Str_19947():Bool
        {
            return this._Str_12302;
        }

	public function new() {}
    }

