package com.sulake.habbo.communication.messages.incoming.tickets
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.tickets.TicketMessageParser;

     class TicketMessageEvent extends MessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, TicketMessageParser);
        }

        public function getParser():TicketMessageParser
        {
            return Std.downcast(this._parser , TicketMessageParser);
        }
    }

