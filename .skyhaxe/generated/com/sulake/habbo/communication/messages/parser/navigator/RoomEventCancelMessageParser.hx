package com.sulake.habbo.communication.messages.parser.navigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomEventCancelMessageParser implements IMessageParser
    {


        public function flush():Bool
        {
            return false;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            return true;
        }

	public function new() {}
    }

