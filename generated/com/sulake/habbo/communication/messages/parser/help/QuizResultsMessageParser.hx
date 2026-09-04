package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class QuizResultsMessageParser implements IMessageParser
    {
        var _Str_3912:String;
        var _Str_6079:Array<ASAny>;


        public function flush():Bool
        {
            this._Str_3912 = null;
            this._Str_6079 = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_3912 = k.readString();
            this._Str_6079 = [];
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._Str_6079.push(k.readInteger());
                _local_3++;
            }
            return true;
        }

        public var _Str_21852(get,never):String;
function  get__Str_21852():String
        {
            return this._Str_3912;
        }

        public var _Str_23947(get,never):Array<ASAny>;
function  get__Str_23947():Array<ASAny>
        {
            return this._Str_6079;
        }

	public function new() {}
    }

