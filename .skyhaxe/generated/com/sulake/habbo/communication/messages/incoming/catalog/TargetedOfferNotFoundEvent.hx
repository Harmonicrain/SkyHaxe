package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.TargetedOfferNotFoundParser;

     class TargetedOfferNotFoundEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, TargetedOfferNotFoundParser);
        }

        public function getParser():TargetedOfferNotFoundParser
        {
            return Std.downcast(this._parser , TargetedOfferNotFoundParser);
        }
    }

