package com.sulake.habbo.communication.messages.parser.inventory.pets
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GoToBreedingNestFailureParser implements IMessageParser
    {
        public static inline final _Str_17785= 6;

        var _reason:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._reason = k.readInteger();
            return true;
        }

        public var reason(get,never):Int;
public function  get_reason():Int
        {
            return this._reason;
        }

	public function new() {}
    }

