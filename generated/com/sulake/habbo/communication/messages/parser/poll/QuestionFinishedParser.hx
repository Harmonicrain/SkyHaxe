package com.sulake.habbo.communication.messages.parser.poll
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class QuestionFinishedParser implements IMessageParser
    {
        var _questionId:Int = 0;
        var _answerCounts:Map;


        public var questionId(get,never):Int;
function  get_questionId():Int
        {
            return this._questionId;
        }

        public var answerCounts(get,never):Map;
function  get_answerCounts():Map
        {
            return this._answerCounts;
        }

        public function flush():Bool
        {
            this._questionId = -1;
            this._answerCounts = null;
            return false;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var key:String;
            var value:Int;
            this._questionId = k.readInteger();
            this._answerCounts = new Map();
            var count= k.readInteger();
            var index = 0;
            while (index < count)
            {
                key = k.readString();
                value = k.readInteger();
                this._answerCounts.add(key, value);
                index++;
            }
            return true;
        }

	public function new() {}
    }

