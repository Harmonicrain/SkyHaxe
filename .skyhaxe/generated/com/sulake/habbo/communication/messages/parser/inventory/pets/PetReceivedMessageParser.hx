package com.sulake.habbo.communication.messages.parser.inventory.pets
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PetReceivedMessageParser implements IMessageParser
    {
        var _boughtAsGift:Bool = false;
        var _pet:Pet;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._boughtAsGift = k.readBoolean();
            this._pet = new Pet(k);
            return true;
        }

        public var boughtAsGift(get,never):Bool;
public function  get_boughtAsGift():Bool
        {
            return this._boughtAsGift;
        }

        public var pet(get,never):Pet;
public function  get_pet():Pet
        {
            return this._pet;
        }

	public function new() {}
    }

