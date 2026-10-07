package com.sulake.habbo.ui.widget.events
;
    import com.sulake.core.utils.Map;

     class RoomWidgetWordQuizUpdateEvent extends RoomWidgetUpdateEvent
    {
        public static inline final RWPUW_NEW_QUESTION= "RWPUW_NEW_QUESTION";
        public static inline final RWPUW_QUESION_FINSIHED= "RWPUW_QUESION_FINSIHED";
        public static inline final RWPUW_QUESTION_ANSWERED= "RWPUW_QUESTION_ANSWERED";

        var _id:Int = -1;
        var _pollType:String = null;
        var _pollId:Int = -1;
        var _questionId:Int = -1;
        var _duration:Int = -1;
        var _question:ASDictionary<ASAny,ASAny> = null;
        var _userId:Int = -1;
        var _value:String;
        var _answerCounts:Map;

        public function new(k:Int, _arg_2:String, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            this._id = k;
            super(_arg_2, _arg_3, _arg_4);
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        
        public var pollType(get,set):String;
public function  get_pollType():String
        {
            return this._pollType;
        }
public function  set_pollType(k:String):String        {
            return this._pollType = k;
        }

        
        public var pollId(get,set):Int;
public function  get_pollId():Int
        {
            return this._pollId;
        }
public function  set_pollId(k:Int):Int        {
            return this._pollId = k;
        }

        
        public var questionId(get,set):Int;
public function  get_questionId():Int
        {
            return this._questionId;
        }
public function  set_questionId(k:Int):Int        {
            return this._questionId = k;
        }

        
        public var duration(get,set):Int;
public function  get_duration():Int
        {
            return this._duration;
        }
public function  set_duration(k:Int):Int        {
            return this._duration = k;
        }

        
        public var question(get,set):ASDictionary<ASAny,ASAny>;
public function  get_question():ASDictionary<ASAny,ASAny>
        {
            return this._question;
        }
public function  set_question(k:ASDictionary<ASAny,ASAny>):ASDictionary<ASAny,ASAny>        {
            return this._question = k;
        }

        
        public var userId(get,set):Int;
public function  get_userId():Int
        {
            return this._userId;
        }
public function  set_userId(k:Int):Int        {
            return this._userId = k;
        }

        
        public var value(get,set):String;
public function  get_value():String
        {
            return this._value;
        }
public function  set_value(k:String):String        {
            return this._value = k;
        }

        
        public var answerCounts(get,set):Map;
public function  get_answerCounts():Map
        {
            return this._answerCounts;
        }
public function  set_answerCounts(k:Map):Map        {
            return this._answerCounts = k;
        }
    }

