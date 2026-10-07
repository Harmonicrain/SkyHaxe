package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.DirectSMSClubBuyAvailableMessageParser;

     class DirectSMSClubBuyAvailableMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, DirectSMSClubBuyAvailableMessageParser);
        }

        public function getParser():DirectSMSClubBuyAvailableMessageParser
        {
            return Std.downcast(this._parser , DirectSMSClubBuyAvailableMessageParser);
        }
    }

