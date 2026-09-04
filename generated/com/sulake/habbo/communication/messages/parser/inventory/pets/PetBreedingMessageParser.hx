package com.sulake.habbo.communication.messages.parser.inventory.pets
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PetBreedingMessageParser implements IMessageParser
    {
        public static inline final _Str_8664= 1;
        public static inline final _Str_9186= 2;
        public static inline final _Str_22195= 3;

        var _state:Int = 0;
        var _ownPetId:Int = 0;
        var _otherPetId:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._state = k.readInteger();
            this._ownPetId = k.readInteger();
            this._otherPetId = k.readInteger();
            return true;
        }

        public var state(get,never):Int;
function  get_state():Int
        {
            return this._state;
        }

        public var ownPetId(get,never):Int;
function  get_ownPetId():Int
        {
            return this._ownPetId;
        }

        public var otherPetId(get,never):Int;
function  get_otherPetId():Int
        {
            return this._otherPetId;
        }

	public function new() {}
    }

