package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuideSessionEndedMessageParser implements IMessageParser 
    {
        var _endReason:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._endReason = k.readInteger();
            return true;
        }

        public var endReason(get,never):Int;
public function  get_endReason():Int
        {
            return this._endReason;
        }

	public function new() {}
    }

