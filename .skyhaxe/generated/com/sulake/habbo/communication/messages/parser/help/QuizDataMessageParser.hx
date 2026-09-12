package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class QuizDataMessageParser implements IMessageParser
    {
        var _Str_3912:String;
        var _Str_5004:Array<ASAny>;


        public function flush():Bool
        {
            this._Str_3912 = null;
            this._Str_5004 = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_3912 = k.readString();
            this._Str_5004 = [];
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._Str_5004.push(k.readInteger());
                _local_3++;
            }
            return true;
        }

        public var _Str_21852(get,never):String;
public function  get__Str_21852():String
        {
            return this._Str_3912;
        }

        public var _Str_25814(get,never):Array<ASAny>;
public function  get__Str_25814():Array<ASAny>
        {
            return this._Str_5004;
        }

	public function new() {}
    }

