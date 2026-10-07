package com.sulake.habbo.communication.messages.parser.room.session
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class OpenConnectionMessageParser implements IMessageParser
    {


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            return true;
        }

	public function new() {}
    }

