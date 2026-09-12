package com.sulake.habbo.communication.messages.parser.campaign
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CampaignCalendarDataMessageParser implements IMessageParser
    {
        var _campaignCalendarData:CampaignCalendarData;

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._campaignCalendarData = new CampaignCalendarData();
            this._campaignCalendarData.parse(k);
            return true;
        }

        public function flush():Bool
        {
            this._campaignCalendarData = null;
            return true;
        }

        public function getCampaignCalenderData():CampaignCalendarData
        {
            return (this._campaignCalendarData != null) ? this._campaignCalendarData.clone() : null;
        }

	public function new() {}
    }

