package com.sulake.habbo.communication.messages.parser.room.pets
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PetRespectFailedParser implements IMessageParser
    {
        var _currentAge:Int = 0;
        var _requiredAge:Int = 0;


        public var currentAge(get,never):Int;
public function  get_currentAge():Int
        {
            return this._currentAge;
        }

        public var requiredAge(get,never):Int;
public function  get_requiredAge():Int
        {
            return this._requiredAge;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._currentAge = k.readInteger();
            this._requiredAge = k.readInteger();
            return true;
        }

	public function new() {}
    }

