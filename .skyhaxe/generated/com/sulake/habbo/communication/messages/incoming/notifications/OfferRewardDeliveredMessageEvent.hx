package com.sulake.habbo.communication.messages.incoming.notifications
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.notifications.OfferRewardDeliveredMessageParser;

     class OfferRewardDeliveredMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, OfferRewardDeliveredMessageParser);
        }

        public function getParser():OfferRewardDeliveredMessageParser
        {
            return Std.downcast(_parser , OfferRewardDeliveredMessageParser);
        }
    }

