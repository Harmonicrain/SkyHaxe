package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.LimitedOfferAppearingNextMessageParser;

     class LimitedOfferAppearingNextMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, LimitedOfferAppearingNextMessageParser);
        }

        public function getParser():LimitedOfferAppearingNextMessageParser
        {
            return Std.downcast(this._parser , LimitedOfferAppearingNextMessageParser);
        }
    }

