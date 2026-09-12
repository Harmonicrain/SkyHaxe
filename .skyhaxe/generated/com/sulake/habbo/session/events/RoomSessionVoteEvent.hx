package com.sulake.habbo.session.events 
;
	import com.sulake.habbo.session.IRoomSession;
	/**
	 * ...
	 * @author 
	 */
	 class RoomSessionVoteEvent extends RoomSessionEvent
	{
		public static inline final VOTE_QUESTION= "RSPE_VOTE_QUESTION";
        public static inline final VOTE_RESULT= "RSPE_VOTE_RESULT";
		
		var _question:String = "";
        var _choices:Array<ASAny>;
        var _SafeStr_7651:Array<ASAny>;
        var _SafeStr_7654:Int = 0;
		
		public function new(_arg_1:String, _arg_2:IRoomSession, _arg_3:String, _arg_4:Array<ASAny>, _arg_5:Array<ASAny>=null, _arg_6:Int=0, _arg_7:Bool=false, _arg_8:Bool=false)
		{
			this._choices = [];
            this._SafeStr_7651 = [];
            super(_arg_1, _arg_2, _arg_7, _arg_8);
            this._question = _arg_3;
            this._choices = _arg_4;
            this._SafeStr_7651 = _arg_5;
            if (this._SafeStr_7651 == null)
            {
                this._SafeStr_7651 = [];
            }
            this._SafeStr_7654 = _arg_6;
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
            return this._SafeStr_7651.slice(0);
        }

        public var _SafeStr_4174(get,never):Int;
public function  get__SafeStr_4174():Int
        {
            return this._SafeStr_7654;
        }
	}


