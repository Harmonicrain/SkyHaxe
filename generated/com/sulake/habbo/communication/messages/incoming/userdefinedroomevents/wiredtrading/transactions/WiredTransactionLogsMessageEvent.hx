package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.transactions.WiredTransactionLogsMessageParser;

     class WiredTransactionLogsMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, WiredTransactionLogsMessageParser);
        }
        public function getParser():WiredTransactionLogsMessageParser
        {
            return Std.downcast(this._parser , WiredTransactionLogsMessageParser);
        }
    }

