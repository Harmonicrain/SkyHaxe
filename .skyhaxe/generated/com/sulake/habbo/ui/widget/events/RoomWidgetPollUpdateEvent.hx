package com.sulake.habbo.ui.widget.events
;
     class RoomWidgetPollUpdateEvent extends RoomWidgetUpdateEvent
    {
        public static inline final RWPUW_OFFER= "RWPUW_OFFER";
        public static inline final ERROR= "RWPUW_ERROR";
        public static inline final RWPUW_CONTENT= "RWPUW_CONTENT";

        var _id:Int = -1;
        var _summary:String;
        var _headline:String;
        var _numQuestions:Int = 0;
        var _startMessage:String = "";
        var _endMessage:String = "";
        var _questionArray:Array<ASAny> = null;
        var _pollType:String = "";
        var _npsPoll:Bool = false;

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

        
        public var summary(get,set):String;
public function  get_summary():String
        {
            return this._summary;
        }
public function  set_summary(k:String):String        {
            return this._summary = k;
        }

        
        public var headline(get,set):String;
public function  get_headline():String
        {
            return this._headline;
        }
public function  set_headline(k:String):String        {
            return this._headline = k;
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

        
        public var pollType(get,set):String;
public function  get_pollType():String
        {
            return this._pollType;
        }
public function  set_pollType(k:String):String        {
            return this._pollType = k;
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

