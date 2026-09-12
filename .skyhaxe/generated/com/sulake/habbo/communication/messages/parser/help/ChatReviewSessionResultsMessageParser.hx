package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ChatReviewSessionResultsMessageParser implements IMessageParser
    {
        var _Str_16293:Int = 0;
        var _Str_16057:Int = 0;
        var _Str_15073:Array<ASAny>;


        public function flush():Bool
        {
            this._Str_16293 = -1;
            this._Str_16057 = -1;
            this._Str_15073 = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_16293 = k.readInteger();
            this._Str_16057 = k.readInteger();
            this._Str_15073 = [];
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._Str_15073.push(k.readInteger());
                _local_3++;
            }
            return true;
        }

        public var _Str_22263(get,never):Int;
public function  get__Str_22263():Int
        {
            return this._Str_16293;
        }

        public var _Str_25395(get,never):Int;
public function  get__Str_25395():Int
        {
            return this._Str_16057;
        }

        public var _Str_24620(get,never):Array<ASAny>;
public function  get__Str_24620():Array<ASAny>
        {
            return this._Str_15073;
        }

	public function new() {}
    }

