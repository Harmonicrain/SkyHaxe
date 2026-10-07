package com.sulake.habbo.communication.messages.parser.inventory.pets
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class NestBreedingSuccessParser implements IMessageParser
    {
        var _Str_5792:Int = 0;
        var _petId:Int = 0;


        public function flush():Bool
        {
            this._petId = -1;
            this._Str_5792 = -1;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._petId = k.readInteger();
            this._Str_5792 = k.readInteger();
            return true;
        }

        public var rarityCategory(get,never):Int;
public function  get_rarityCategory():Int
        {
            return this._Str_5792;
        }

        public var petId(get,never):Int;
public function  get_petId():Int
        {
            return this._petId;
        }

	public function new() {}
    }

