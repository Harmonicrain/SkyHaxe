package com.sulake.habbo.ui.widget.infobuspolls 
;
	import com.sulake.core.communication.messages.IMessageDataWrapper;
	import com.sulake.core.communication.messages.IMessageParser;
	/**
	 * ...
	 * @author 
	 */
	 class RoomPollResultParser implements IMessageParser
	{
		var _question:String;
        var _choices:Array<ASAny>;
        var _SafeStr_7651:Array<ASAny>;
        var _SafeStr_7654:Int = 0;


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

        public function flush():Bool
        {
            this._question = "";
            this._choices = [];
            this._SafeStr_7651 = [];
            this._SafeStr_7654 = 0;
            return true;
        }

        public function parse(_arg_1:IMessageDataWrapper):Bool
        {
            this._question = _arg_1.readString();
            this._choices = [];
            this._SafeStr_7651 = [];
            var _local_2= _arg_1.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _arg_1.readInteger();
                this._choices.push(_arg_1.readString());
                this._SafeStr_7651.push(_arg_1.readInteger());
                _local_3++;
            }
            this._SafeStr_7654 = _arg_1.readInteger();
            return true;
        }

	public function new() {}

	}


