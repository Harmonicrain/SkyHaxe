package com.sulake.habbo.communication.messages.incoming.campaign
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.campaign.CampaignCalendarDoorOpenedMessageParser;

     class CampaignCalendarDoorOpenedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CampaignCalendarDoorOpenedMessageParser);
        }

        public function getParser():CampaignCalendarDoorOpenedMessageParser
        {
            return Std.downcast(_parser , CampaignCalendarDoorOpenedMessageParser);
        }
    }

