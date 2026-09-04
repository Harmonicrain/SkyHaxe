package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.chests
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests.ChestCoinBalanceMessageParser;

     class ChestCoinBalanceMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, ChestCoinBalanceMessageParser);
        }
        public function getParser():ChestCoinBalanceMessageParser
        {
            return Std.downcast(this._parser , ChestCoinBalanceMessageParser);
        }
    }

