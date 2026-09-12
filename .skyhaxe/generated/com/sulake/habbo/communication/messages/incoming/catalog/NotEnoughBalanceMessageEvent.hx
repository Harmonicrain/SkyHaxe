package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.NotEnoughBalanceMessageParser;

     class NotEnoughBalanceMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, NotEnoughBalanceMessageParser);
        }

        public function getParser():NotEnoughBalanceMessageParser
        {
            return Std.downcast(this._parser , NotEnoughBalanceMessageParser);
        }
    }

