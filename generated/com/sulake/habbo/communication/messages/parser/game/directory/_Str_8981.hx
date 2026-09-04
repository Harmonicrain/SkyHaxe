package com.sulake.habbo.communication.messages.parser.game.directory
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class _Str_8981 implements IMessageParser 
    {
        var _Str_19201:Int = 0;


        public function flush():Bool
        {
            return false;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_19201 = k.readInteger();
            return true;
        }

        public var _Str_26145(get,never):Int;
function  get__Str_26145():Int
        {
            return this._Str_19201;
        }

	public function new() {}
    }

