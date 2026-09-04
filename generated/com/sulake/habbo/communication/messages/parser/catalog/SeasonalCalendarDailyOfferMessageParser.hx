package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.catalog.CatalogPageMessageOfferData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SeasonalCalendarDailyOfferMessageParser implements IMessageParser
    {
        var _pageId:Int = 0;
        var _Str_8357:CatalogPageMessageOfferData;


        public function flush():Bool
        {
            this._pageId = -1;
            this._Str_8357 = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._pageId = k.readInteger();
            this._Str_8357 = new CatalogPageMessageOfferData(k);
            return true;
        }

        public var pageId(get,never):Int;
function  get_pageId():Int
        {
            return this._pageId;
        }

        public var _Str_17889(get,never):CatalogPageMessageOfferData;
function  get__Str_17889():CatalogPageMessageOfferData
        {
            return this._Str_8357;
        }

	public function new() {}
    }

