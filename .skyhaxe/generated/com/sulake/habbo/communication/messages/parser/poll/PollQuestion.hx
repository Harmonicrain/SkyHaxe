package com.sulake.habbo.communication.messages.parser.poll
;

     class PollQuestion 
    {
        public static inline final _Str_12458= 0;
        public static inline final _Str_19176= 1;
        public static inline final _Str_20133= 2;
        public static inline final _Str_20448= 3;

        var _questionId:Int = 0;
        var _questionType:Int = 0;
        var _sortOrder:Int = 0;
        var _questionCategory:Int = 0;
        var _questionText:String;
        var _questionAnswerType:Int = 0;
        var _questionAnswerCount:Int = 0;
        var _children:Vector<PollQuestion>;
        var _questionChoices:Vector<QuestionChoice>;

        public function new()
        {
            this._children = new Vector<PollQuestion>();
            this._questionChoices = new Vector<QuestionChoice>();
        }

        
        public var questionId(get,set):Int;
public function  get_questionId():Int
        {
            return this._questionId;
        }
public function  set_questionId(k:Int):Int        {
            return this._questionId = k;
        }

        
        public var questionType(get,set):Int;
public function  get_questionType():Int
        {
            return this._questionType;
        }
public function  set_questionType(k:Int):Int        {
            return this._questionType = k;
        }

        
        public var sortOrder(get,set):Int;
public function  get_sortOrder():Int
        {
            return this._sortOrder;
        }
public function  set_sortOrder(sortOrder:Int):Int        {
            return this._sortOrder = sortOrder;
        }

        
        public var questionText(get,set):String;
public function  get_questionText():String
        {
            return this._questionText;
        }
public function  set_questionText(k:String):String        {
            return this._questionText = k;
        }

        
        public var questionCategory(get,set):Int;
public function  get_questionCategory():Int
        {
            return this._questionCategory;
        }
public function  set_questionCategory(k:Int):Int        {
            return this._questionCategory = k;
        }

        
        public var questionAnswerType(get,set):Int;
public function  get_questionAnswerType():Int
        {
            return this._questionAnswerType;
        }
public function  set_questionAnswerType(k:Int):Int        {
            return this._questionAnswerType = k;
        }

        
        public var questionAnswerCount(get,set):Int;
public function  get_questionAnswerCount():Int
        {
            return this._questionAnswerCount;
        }
public function  set_questionAnswerCount(k:Int):Int        {
            return this._questionAnswerCount = k;
        }

        
        public var children(get,set):Vector<PollQuestion>;
public function  get_children():Vector<PollQuestion>
        {
            return this._children;
        }
public function  set_children(children:Vector<PollQuestion>):Vector<PollQuestion>        {
            return this._children = children;
        }

        
        public var questionChoices(get,set):Vector<QuestionChoice>;
public function  get_questionChoices():Vector<QuestionChoice>
        {
            return this._questionChoices;
        }
public function  set_questionChoices(k:Vector<QuestionChoice>):Vector<QuestionChoice>        {
            return this._questionChoices = k;
        }
    }

