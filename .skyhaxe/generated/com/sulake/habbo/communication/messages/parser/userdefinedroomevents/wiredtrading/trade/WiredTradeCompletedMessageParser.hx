package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.trade
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class WiredTradeCompletedMessageParser implements IMessageParser
    {
        public function flush():Bool { return true; }
        public function parse(data:IMessageDataWrapper):Bool
        { return data.bytesAvailable == 0; }

	public function new() {}
    }

