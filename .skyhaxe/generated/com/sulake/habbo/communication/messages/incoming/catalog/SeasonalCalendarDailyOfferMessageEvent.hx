package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.SeasonalCalendarDailyOfferMessageParser;

     class SeasonalCalendarDailyOfferMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, SeasonalCalendarDailyOfferMessageParser);
        }

        public var offer(get,never):CatalogPageMessageOfferData;
public function  get_offer():CatalogPageMessageOfferData
        {
            return cast(parser, SeasonalCalendarDailyOfferMessageParser)._Str_17889;
        }

        public var pageId(get,never):Int;
public function  get_pageId():Int
        {
            return cast(parser, SeasonalCalendarDailyOfferMessageParser).pageId;
        }
    }

