package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FaqTextMessageParser implements IMessageParser
    {
        var _questionId:Int = 0;
        var _answerText:String;


        public var questionId(get,never):Int;
function  get_questionId():Int
        {
            return this._questionId;
        }

        public var _Str_26387(get,never):String;
function  get__Str_26387():String
        {
            return this._answerText;
        }

        public function flush():Bool
        {
            this._questionId = -1;
            this._answerText = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._questionId = k.readInteger();
            this._answerText = k.readString();
            return true;
        }

	public function new() {}
    }

