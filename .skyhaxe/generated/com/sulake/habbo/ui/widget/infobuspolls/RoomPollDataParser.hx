package com.sulake.habbo.ui.widget.infobuspolls 
;
	import com.sulake.core.communication.messages.IMessageDataWrapper;
	import com.sulake.core.communication.messages.IMessageParser;
	/**
	 * ...
	 * @author 
	 */
	 class RoomPollDataParser implements IMessageParser
	{
	
		
	var _question:String;
        var _choices:Array<ASAny>;


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

        public function flush():Bool
        {
            this._question = "";
            this._choices = [];
            return true;
        }

        public function parse(_arg_1:IMessageDataWrapper):Bool
        {
            this._question = _arg_1.readString();
            this._choices = [];
            var _local_2= _arg_1.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _arg_1.readInteger();
                this._choices.push(_arg_1.readString());
                _local_3++;
            }
            return true;
        }

	public function new() {}
	}

