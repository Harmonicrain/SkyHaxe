package com.sulake.habbo.communication.messages.incoming.campaign
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.campaign.CampaignCalendarDataMessageParser;

     class CampaignCalendarDataMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CampaignCalendarDataMessageParser);
        }

        public function getParser():CampaignCalendarDataMessageParser
        {
            return Std.downcast(_parser , CampaignCalendarDataMessageParser);
        }
    }

