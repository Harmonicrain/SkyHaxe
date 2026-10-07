package com.sulake.habbo.ui.widget.events 
;
	 class RoomWidgetVoteUpdateEvent extends RoomWidgetUpdateEvent
	{
		
		public static inline final VOTE_QUESTION= "RWPUE_VOTE_QUESTION"; //_SafeStr_4171
        public static inline final VOTE_RESULT= "RWPUE_VOTE_RESULT"; //_SafeStr_4172

        var _question:String;
        var _choices:Array<ASAny>;
        var _SafeStr_7651:Array<ASAny>;
        var _SafeStr_7654:Int = 0;

        public function new(_arg_1:String, _arg_2:String, _arg_3:Array<ASAny>, _arg_4:Array<ASAny>=null, _arg_5:Int=0, _arg_6:Bool=false, _arg_7:Bool=false)
        {
            super(_arg_1, _arg_6, _arg_7);
            this._question = _arg_2;
            this._choices = _arg_3;
            this._SafeStr_7651 = _arg_4;
            if (this._SafeStr_7651 == null)
            {
                this._SafeStr_7651 = [];
            }
            this._SafeStr_7654 = _arg_5;
        }

        public var question(get,never):String;
public function  get_question():String
        {
            return this._question;
        }

        public var choices(get,never):Array<ASAny>;
public function  get_choices():Array<ASAny>
        {
            return this._choices.slice(0);
        }

        public var _SafeStr_4173(get,never):Array<ASAny>;
public function  get__SafeStr_4173():Array<ASAny>
        {
            return this._SafeStr_7651.slice(0); //Results?
        }

        public var _SafeStr_4174(get,never):Int;
public function  get__SafeStr_4174():Int
        {
            return this._SafeStr_7654; //Timer?
        }
	}

