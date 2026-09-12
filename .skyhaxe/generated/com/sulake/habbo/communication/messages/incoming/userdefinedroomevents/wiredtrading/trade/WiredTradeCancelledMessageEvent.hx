package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.trade
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.trade.WiredTradeCancelledMessageParser;

     class WiredTradeCancelledMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        { super(callback, WiredTradeCancelledMessageParser); }
        public function getParser():WiredTradeCancelledMessageParser
        { return Std.downcast(this._parser , WiredTradeCancelledMessageParser); }
    }

