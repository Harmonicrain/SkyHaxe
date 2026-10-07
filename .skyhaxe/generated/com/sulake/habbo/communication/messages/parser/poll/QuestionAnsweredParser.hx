package com.sulake.habbo.communication.messages.parser.poll
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class QuestionAnsweredParser implements IMessageParser
    {
        var _userId:Int = 0;
        var _value:String;
        var _answerCounts:Map;


        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var value(get,never):String;
public function  get_value():String
        {
            return this._value;
        }

        public var answerCounts(get,never):Map;
public function  get_answerCounts():Map
        {
            return this._answerCounts;
        }

        public function flush():Bool
        {
            this._userId = -1;
            this._value = "";
            this._answerCounts = null;
            return false;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var key:String = null;
            var value = 0;
            this._userId = k.readInteger();
            this._value = k.readString();
            this._answerCounts = new Map();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                key = k.readString();
                value = k.readInteger();
                this._answerCounts.add(key, value);
                _local_3++;
            }
            return true;
        }

	public function new() {}
    }

