package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.catalog.CatalogLocalizationData;
    import com.sulake.habbo.communication.messages.incoming.catalog.CatalogPageMessageOfferData;
    import com.sulake.habbo.communication.messages.incoming.catalog.FrontPageItem;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CatalogPageMessageParser implements IMessageParser 
    {
        var _pageId:Int = 0;
        var _catalogType:String;
        var _layoutCode:String;
        var _localization:CatalogLocalizationData;
        var _offers:Vector<CatalogPageMessageOfferData>;
        var _offerId:Int = 0;
        var _acceptSeasonCurrencyAsCredits:Bool = false;
        var _frontPageItems:Vector<FrontPageItem>;


        public var pageId(get,never):Int;
public function  get_pageId():Int
        {
            return this._pageId;
        }

        public var catalogType(get,never):String;
public function  get_catalogType():String
        {
            return this._catalogType;
        }

        public var layoutCode(get,never):String;
public function  get_layoutCode():String
        {
            return this._layoutCode;
        }

        public var localization(get,never):CatalogLocalizationData;
public function  get_localization():CatalogLocalizationData
        {
            return this._localization;
        }

        public var offers(get,never):Vector<CatalogPageMessageOfferData>;
public function  get_offers():Vector<CatalogPageMessageOfferData>
        {
            return this._offers;
        }

        public var offerId(get,never):Int;
public function  get_offerId():Int
        {
            return this._offerId;
        }

        public var acceptSeasonCurrencyAsCredits(get,never):Bool;
public function  get_acceptSeasonCurrencyAsCredits():Bool
        {
            return this._acceptSeasonCurrencyAsCredits;
        }

        public var frontPageItems(get,never):Vector<FrontPageItem>;
public function  get_frontPageItems():Vector<FrontPageItem>
        {
            return this._frontPageItems;
        }

        public function flush():Bool
        {
            this._pageId = -1;
            this._catalogType = "";
            this._layoutCode = "";
            this._localization = null;
            this._offers = new Vector<CatalogPageMessageOfferData>(0);
            this._offerId = -1;
            this._acceptSeasonCurrencyAsCredits = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._pageId = k.readInteger();
            this._catalogType = k.readString();
            this._layoutCode = k.readString();
            this._localization = new CatalogLocalizationData(k);
            this._offers = new Vector<CatalogPageMessageOfferData>(0);
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._offers.push(new CatalogPageMessageOfferData(k));
                _local_3++;
            }
            this._offerId = k.readInteger(); //usually -1, whyever would a CatalogPage have an offerId anyways?
            this._acceptSeasonCurrencyAsCredits = k.readBoolean();
            if (k.bytesAvailable != 0)
            {
                this._frontPageItems = new Vector<FrontPageItem>(0);
                _local_2 = k.readInteger();
                _local_3 = 0;
                while (_local_3 < _local_2)
                {
                    this._frontPageItems.push(new FrontPageItem(k));
                    _local_3++;
                }
            }
            return true;
        }

	public function new() {}
    }

