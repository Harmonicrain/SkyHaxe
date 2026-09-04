package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.transactions.WiredTransactionDetailsMessageParser;

     class WiredTransactionDetailsMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, WiredTransactionDetailsMessageParser);
        }
        public function getParser():WiredTransactionDetailsMessageParser
        {
            return Std.downcast(this._parser , WiredTransactionDetailsMessageParser);
        }
    }

