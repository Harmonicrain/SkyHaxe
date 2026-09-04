package com.sulake.habbo.communication.messages.parser.inventory.pets
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PetRemovedFromInventoryParser implements IMessageParser
    {
        var _petId:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._petId = k.readInteger();
            return true;
        }

        public var petId(get,never):Int;
function  get_petId():Int
        {
            return this._petId;
        }

	public function new() {}
    }

