package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CatalogPageMessageOfferData 
    {
        var _offerId:Int = 0;
        var _localizationId:String;
        var _rent:Bool = false;
        var _priceInCredits:Int = 0;
        var _priceInActivityPoints:Int = 0;
        var _activityPointType:Int = 0;
        var _clubLevel:Int = 0;
        var _giftable:Bool = false;
        var _bundlePurchaseAllowed:Bool = false;
        var _isPet:Bool = false;
        var _previewImage:String;
        var _products:Vector<CatalogPageMessageProductData>;

        public function new(k:IMessageDataWrapper)
        {
            this._offerId = k.readInteger();
            this._localizationId = k.readString();
            this._rent = k.readBoolean();
            this._priceInCredits = k.readInteger();
            this._priceInActivityPoints = k.readInteger();
            this._activityPointType = k.readInteger();
            this._giftable = k.readBoolean();
            var _local_2= k.readInteger();
            this._products = new Vector<CatalogPageMessageProductData>(0);
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._products.push(new CatalogPageMessageProductData(k));
                _local_3++;
            }
            this._clubLevel = k.readInteger();
            this._bundlePurchaseAllowed = k.readBoolean();
            this._isPet = k.readBoolean();
            this._previewImage = k.readString();
        }

        public var offerId(get,never):Int;
function  get_offerId():Int
        {
            return this._offerId;
        }

        public var localizationId(get,never):String;
function  get_localizationId():String
        {
            return this._localizationId;
        }

        public var isRent(get,never):Bool;
function  get_isRent():Bool
        {
            return this._rent;
        }

        public var priceInCredits(get,never):Int;
function  get_priceInCredits():Int
        {
            return this._priceInCredits;
        }

        public var priceInActivityPoints(get,never):Int;
function  get_priceInActivityPoints():Int
        {
            return this._priceInActivityPoints;
        }

        public var products(get,never):Vector<CatalogPageMessageProductData>;
function  get_products():Vector<CatalogPageMessageProductData>
        {
            return this._products;
        }

        public var activityPointType(get,never):Int;
function  get_activityPointType():Int
        {
            return this._activityPointType;
        }

        public var clubLevel(get,never):Int;
function  get_clubLevel():Int
        {
            return this._clubLevel;
        }

        public var giftable(get,never):Bool;
function  get_giftable():Bool
        {
            return this._giftable;
        }

        public var bundlePurchaseAllowed(get,never):Bool;
function  get_bundlePurchaseAllowed():Bool
        {
            return this._bundlePurchaseAllowed;
        }

        public var previewImage(get,never):String;
function  get_previewImage():String
        {
            return this._previewImage;
        }
    }

