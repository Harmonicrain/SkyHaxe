package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetPollMessage extends RoomWidgetMessage 
    {
        public static inline final RWPM_START= "RWPM_START";
        public static inline final RWPM_REJECT= "RWPM_REJECT";
        public static inline final RWPM_ANSWER= "RWPM_ANSWER";

        var _id:Int = -1;
        var _questionId:Int = 0;
        var _answers:Array<ASAny> = null;

        public function new(k:String, _arg_2:Int)
        {
            this._id = _arg_2;
            super(k);
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        
        public var questionId(get,set):Int;
public function  get_questionId():Int
        {
            return this._questionId;
        }
public function  set_questionId(k:Int):Int        {
            return this._questionId = k;
        }

        
        public var answers(get,set):Array<ASAny>;
public function  get_answers():Array<ASAny>
        {
            return this._answers;
        }
public function  set_answers(k:Array<ASAny>):Array<ASAny>        {
            return this._answers = k;
        }
    }

