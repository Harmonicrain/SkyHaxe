package com.sulake.habbo.session.events
;
    import com.sulake.habbo.session.IRoomSession;

     class RoomSessionPollEvent extends RoomSessionEvent
    {
        public static inline final RSPE_POLL_OFFER= "RSPE_POLL_OFFER";
        public static inline final ERROR= "RSPE_POLL_ERROR";
        public static inline final RSPE_POLL_CONTENT= "RSPE_POLL_CONTENT";

        var _id:Int = -1;
        var _headline:String;
        var _summary:String;
        var _numQuestions:Int = 0;
        var _startMessage:String = "";
        var _endMessage:String = "";
        var _questionArray:Array<ASAny> = null;
        var _npsPoll:Bool = false;

        public function new(k:String, _arg_2:IRoomSession, _arg_3:Int)
        {
            this._id = _arg_3;
            super(k, _arg_2);
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        
        public var headline(get,set):String;
public function  get_headline():String
        {
            return this._headline;
        }
public function  set_headline(k:String):String        {
            return this._headline = k;
        }

        
        public var summary(get,set):String;
public function  get_summary():String
        {
            return this._summary;
        }
public function  set_summary(k:String):String        {
            return this._summary = k;
        }

        
        public var numQuestions(get,set):Int;
public function  get_numQuestions():Int
        {
            return this._numQuestions;
        }
public function  set_numQuestions(k:Int):Int        {
            return this._numQuestions = k;
        }

        
        public var _Str_6013(get,set):String;
public function  get__Str_6013():String
        {
            return this._startMessage;
        }
public function  set__Str_6013(k:String):String        {
            return this._startMessage = k;
        }

        
        public var _Str_5838(get,set):String;
public function  get__Str_5838():String
        {
            return this._endMessage;
        }
public function  set__Str_5838(k:String):String        {
            return this._endMessage = k;
        }

        
        public var _Str_5643(get,set):Array<ASAny>;
public function  get__Str_5643():Array<ASAny>
        {
            return this._questionArray;
        }
public function  set__Str_5643(k:Array<ASAny>):Array<ASAny>        {
            return this._questionArray = k;
        }

        
        public var _Str_6196(get,set):Bool;
public function  get__Str_6196():Bool
        {
            return this._npsPoll;
        }
public function  set__Str_6196(k:Bool):Bool        {
            return this._npsPoll = k;
        }
    }

