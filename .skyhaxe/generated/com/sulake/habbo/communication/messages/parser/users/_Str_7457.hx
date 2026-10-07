package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class _Str_7457 implements IMessageParser 
    {
        var _result:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._result = k.readInteger();
            return true;
        }

        public var result(get,never):Int;
public function  get_result():Int
        {
            return this._result;
        }

	public function new() {}
    }

