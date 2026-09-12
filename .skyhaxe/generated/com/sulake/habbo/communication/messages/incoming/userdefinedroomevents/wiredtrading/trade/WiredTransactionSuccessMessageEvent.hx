package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.trade
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.trade.WiredTransactionSuccessMessageParser;

     class WiredTransactionSuccessMessageEvent extends MessageEvent
        implements IMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, WiredTransactionSuccessMessageParser);
        }

        public function getParser():WiredTransactionSuccessMessageParser
        {
            return Std.downcast(this._parser , WiredTransactionSuccessMessageParser);
        }
    }

