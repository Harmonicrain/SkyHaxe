package com.sulake.habbo.communication.messages.incoming.perk
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.perk.CitizenshipVipOfferPromoEnabledMessageParser;

     class CitizenshipVipOfferPromoEnabledEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CitizenshipVipOfferPromoEnabledMessageParser);
        }

        public function getParser():CitizenshipVipOfferPromoEnabledMessageParser
        {
            return Std.downcast(_parser , CitizenshipVipOfferPromoEnabledMessageParser);
        }
    }

