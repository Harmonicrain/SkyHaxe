package com.sulake.habbo.communication.messages.parser.inventory.furni
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FurniListInvalidateParser implements IMessageParser 
    {


        public function parse(k:IMessageDataWrapper):Bool
        {
            return true;
        }

        public function flush():Bool
        {
            return true;
        }

	public function new() {}
    }

