package com.sulake.habbo.communication.messages.parser.inventory.pets
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ConfirmBreedingResultParser implements IMessageParser
    {
        var _Str_6143:Int = 0;
        var _result:Int = 0;


        public function flush():Bool
        {
            this._Str_6143 = 0;
            this._result = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_6143 = k.readInteger();
            this._result = k.readInteger();
            return true;
        }

        public var breedingNestStuffId(get,never):Int;
public function  get_breedingNestStuffId():Int
        {
            return this._Str_6143;
        }

        public var result(get,never):Int;
public function  get_result():Int
        {
            return this._result;
        }

	public function new() {}
    }

