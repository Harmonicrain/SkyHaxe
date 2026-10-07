package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.HabboClubExtendOfferMessageParser;

     class HabboClubExtendOfferMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, HabboClubExtendOfferMessageParser);
        }

        public function getParser():HabboClubExtendOfferMessageParser
        {
            return Std.downcast(this._parser , HabboClubExtendOfferMessageParser);
        }
    }

