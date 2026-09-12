package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.LimitedEditionSoldOutParser;

     class LimitedEditionSoldOutEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, LimitedEditionSoldOutParser);
        }

        public function getParser():LimitedEditionSoldOutParser
        {
            return Std.downcast(this._parser , LimitedEditionSoldOutParser);
        }
    }

