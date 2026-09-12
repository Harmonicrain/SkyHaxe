package com.sulake.habbo.communication.messages.parser.poll
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PollContentsParser implements IMessageParser 
    {
        var _id:Int = -1;
        var _startMessage:String = "";
        var _endMessage:String = "";
        var _numQuestions:Int = 0;
        var _questionArray:Array<ASAny> = null;
        var _npsPoll:Bool = false;


        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var _Str_6013(get,never):String;
public function  get__Str_6013():String
        {
            return this._startMessage;
        }

        public var _Str_5838(get,never):String;
public function  get__Str_5838():String
        {
            return this._endMessage;
        }

        public var numQuestions(get,never):Int;
public function  get_numQuestions():Int
        {
            return this._numQuestions;
        }

        public var _Str_5643(get,never):Array<ASAny>;
public function  get__Str_5643():Array<ASAny>
        {
            return this._questionArray;
        }

        public var _Str_6196(get,never):Bool;
public function  get__Str_6196():Bool
        {
            return this._npsPoll;
        }

        public function flush():Bool
        {
            this._id = -1;
            this._startMessage = "";
            this._endMessage = "";
            this._numQuestions = 0;
            this._questionArray = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_3:PollQuestion = null;
            var _local_4 = 0;
            var _local_5 = 0;
            this._id = k.readInteger();
            this._startMessage = k.readString();
            this._endMessage = k.readString();
            this._numQuestions = k.readInteger();
            this._questionArray = new Array<ASAny>();
            var _local_2 = 0;
            while (_local_2 < this._numQuestions)
            {
                _local_3 = this.parsePollQuestion(k);
                _local_4 = k.readInteger();
                _local_5 = 0;
                while (_local_5 < _local_4)
                {
                    _local_3.children.push(this.parsePollQuestion(k));
                    _local_5++;
                }
                this._questionArray.push(_local_3);
                _local_2++;
            }
            this._npsPoll = k.readBoolean();
            return true;
        }

        function parsePollQuestion(k:IMessageDataWrapper):PollQuestion
        {
            var _local_3 = 0;
            var pollQuestion= new PollQuestion();
            pollQuestion.questionId = k.readInteger();
            pollQuestion.sortOrder = k.readInteger();
            pollQuestion.questionType = k.readInteger();
            pollQuestion.questionText = k.readString();
            pollQuestion.questionCategory = k.readInteger();
            pollQuestion.questionAnswerType = k.readInteger();
            pollQuestion.questionAnswerCount = k.readInteger();
            if (((pollQuestion.questionType == 1) || (pollQuestion.questionType == 2)))
            {
                _local_3 = 0;
                while (_local_3 < pollQuestion.questionAnswerCount)
                {
                    pollQuestion.questionChoices.push(new QuestionChoice(k.readString(), k.readString(), k.readInteger()));
                    _local_3++;
                }
            }
            return pollQuestion;
        }

	public function new() {}
    }

