package com.sulake.habbo.communication.messages.parser.game.directory
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class _Str_8889 implements IMessageParser 
    {
        var _Str_16950:Int = 0;


        public function flush():Bool
        {
            this._Str_16950 = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_16950 = k.readInteger();
            return true;
        }

        public var _Str_26420(get,never):Int;
function  get__Str_26420():Int
        {
            return this._Str_16950;
        }

	public function new() {}
    }

