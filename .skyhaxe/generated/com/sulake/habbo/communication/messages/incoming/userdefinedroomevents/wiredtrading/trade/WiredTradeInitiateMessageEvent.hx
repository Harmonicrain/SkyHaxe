package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.trade
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.trade.WiredTradeInitiateMessageParser;

     class WiredTradeInitiateMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        { super(callback, WiredTradeInitiateMessageParser); }
        public function getParser():WiredTradeInitiateMessageParser
        { return Std.downcast(this._parser , WiredTradeInitiateMessageParser); }
    }

