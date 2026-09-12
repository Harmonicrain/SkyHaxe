package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.purse.CreditBalanceParser;

     class CreditBalanceEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CreditBalanceParser);
        }

        public function getParser():CreditBalanceParser
        {
            return Std.downcast(this._parser , CreditBalanceParser);
        }
    }

