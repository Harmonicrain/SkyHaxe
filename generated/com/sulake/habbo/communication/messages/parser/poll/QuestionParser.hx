package com.sulake.habbo.communication.messages.parser.poll
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class QuestionParser implements IMessageParser 
    {
        var _pollType:String = null;
        var _pollId:Int = -1;
        var _questionId:Int = -1;
        var _duration:Int = -1;
        var _question:ASDictionary<ASAny,ASAny> = null;


        public var pollType(get,never):String;
function  get_pollType():String
        {
            return this._pollType;
        }

        public var pollId(get,never):Int;
function  get_pollId():Int
        {
            return this._pollId;
        }

        public var questionId(get,never):Int;
function  get_questionId():Int
        {
            return this._questionId;
        }

        public var duration(get,never):Int;
function  get_duration():Int
        {
            return this._duration;
        }

        public var question(get,never):ASDictionary<ASAny,ASAny>;
function  get_question():ASDictionary<ASAny,ASAny>
        {
            return this._question;
        }

        public function flush():Bool
        {
            this._pollType = null;
            this._pollId = -1;
            this._questionId = -1;
            this._duration = -1;
            this._question = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2:Int;
            var _local_3:Array<ASAny>;
            var _local_4:Array<ASAny>;
            var _local_5:Int;
            this._pollType = k.readString();
            this._pollId = k.readInteger();
            this._questionId = k.readInteger();
            this._duration = k.readInteger();
            this._question = new ASDictionary<ASAny,ASAny>();
            this._question["id"] = k.readInteger();
            this._question["number"] = k.readInteger();
            this._question["type"] = k.readInteger();
            this._question["content"] = k.readString();
            if (((this._question["type"] == 1) || (this._question["type"] == 2)))
            {
                this._question["selection_min"] = k.readInteger();
                _local_2 = k.readInteger();
                _local_3 = new Array<ASAny>();
                _local_4 = new Array<ASAny>();
                this._question["selections"] = _local_3;
                this._question["selection_values"] = _local_4;
                this._question["selection_count"] = _local_2;
                this._question["selection_max"] = _local_2;
                _local_5 = 0;
                while (_local_5 < _local_2)
                {
                    _local_4.push(k.readString());
                    _local_3.push(k.readString());
                    _local_5++;
                }
            }
            return true;
        }

	public function new() {}
    }

