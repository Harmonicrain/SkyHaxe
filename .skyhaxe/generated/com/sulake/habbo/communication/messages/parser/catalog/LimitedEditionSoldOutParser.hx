package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class LimitedEditionSoldOutParser implements IMessageParser
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

