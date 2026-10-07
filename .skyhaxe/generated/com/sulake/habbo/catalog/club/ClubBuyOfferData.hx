package com.sulake.habbo.catalog.club
;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.habbo.catalog.viewer.ICatalogPage;
    import com.sulake.habbo.catalog.viewer.Offer;
    import com.sulake.habbo.catalog.viewer.IProductContainer;
    import com.sulake.habbo.catalog.viewer.IProduct;
    import com.sulake.habbo.catalog.viewer.IGridItem;

     class ClubBuyOfferData implements IPurchasableOffer 
    {
        var _offerId:Int = 0;
        var _productCode:String;
        var _priceCredits:Int = 0;
        var _priceActivityPoints:Int = 0;
        var _priceActivityPointType:Int = 0;
        var _vip:Bool = false;
        var _months:Int = 0;
        var _daysLeftAfterPurchase:Int = 0;
        var _page:ICatalogPage;
        var _year:Int = 0;
        var _month:Int = 0;
        var _day:Int = 0;
        var _extraParameter:String;
        var _upgradeHcPeriodToVip:Bool = false;
        var _disposed:Bool = false;
        var _extraDays:Int = 0;
        var _giftable:Bool = false;

        public function new(k:Int, _arg_2:String, _arg_3:Int, _arg_4:Int, _arg_5:Int, _arg_6:Bool, _arg_7:Int, _arg_8:Int, _arg_9:Int, _arg_10:Int, _arg_11:Int, _arg_12:Int, _arg_13:Bool=false)
        {
            this._offerId = k;
            this._productCode = _arg_2;
            this._priceCredits = _arg_3;
            this._priceActivityPoints = _arg_4;
            this._priceActivityPointType = _arg_5;
            this._vip = _arg_6;
            this._months = _arg_7;
            this._extraDays = _arg_8;
            this._daysLeftAfterPurchase = _arg_9;
            this._year = _arg_10;
            this._month = _arg_11;
            this._day = _arg_12;
            this._giftable = _arg_13;
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            this._disposed = true;
            this._page = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        
        public var extraParameter(get,set):String;
public function  get_extraParameter():String
        {
            return this._extraParameter;
        }
public function  set_extraParameter(k:String):String        {
            return this._extraParameter = k;
        }

        public var offerId(get,never):Int;
public function  get_offerId():Int
        {
            return this._offerId;
        }

        public var productCode(get,never):String;
public function  get_productCode():String
        {
            return this._productCode;
        }

        public var priceCredits(get,never):Int;
public function  get_priceCredits():Int
        {
            return this._priceCredits;
        }

        public var vip(get,never):Bool;
public function  get_vip():Bool
        {
            return this._vip;
        }

        public var months(get,never):Int;
public function  get_months():Int
        {
            return this._months;
        }

        public var _Str_11224(get,never):Int;
public function  get__Str_11224():Int
        {
            return this._daysLeftAfterPurchase;
        }

        public var year(get,never):Int;
public function  get_year():Int
        {
            return this._year;
        }

        public var month(get,never):Int;
public function  get_month():Int
        {
            return this._month;
        }

        public var day(get,never):Int;
public function  get_day():Int
        {
            return this._day;
        }

        public var _Str_18028(get,never):Bool;
public function  get__Str_18028():Bool
        {
            return this._giftable;
        }

        public var priceInActivityPoints(get,never):Int;
public function  get_priceInActivityPoints():Int
        {
            return this._priceActivityPoints;
        }

        public var activityPointType(get,never):Int;
public function  get_activityPointType():Int
        {
            return this._priceActivityPointType;
        }

        public var priceInCredits(get,never):Int;
public function  get_priceInCredits():Int
        {
            return this._priceCredits;
        }

        
        public var page(get,set):ICatalogPage;
public function  get_page():ICatalogPage
        {
            return this._page;
        }

        public var priceType(get,never):String;
public function  get_priceType():String
        {
            return Offer.PRICE_TYPE_CREDITS;
        }

        public var productContainer(get,never):IProductContainer;
public function  get_productContainer():IProductContainer
        {
            return null;
        }

        public var product(get,never):IProduct;
public function  get_product():IProduct
        {
            return (this.productContainer != null) ? this.productContainer._Str_6851 : null;
        }

        public var gridItem(get,never):IGridItem;
public function  get_gridItem():IGridItem
        {
            return null;
        }

        public var localizationId(get,never):String;
public function  get_localizationId():String
        {
            return this._productCode;
        }
public function  set_page(k:ICatalogPage):ICatalogPage        {
            return this._page = k;
        }

        
        public var _Str_10047(get,set):Bool;
public function  get__Str_10047():Bool
        {
            return this._upgradeHcPeriodToVip;
        }
public function  set__Str_10047(k:Bool):Bool        {
            return this._upgradeHcPeriodToVip = k;
        }

        public var _Str_15178(get,never):Int;
public function  get__Str_15178():Int
        {
            return this._extraDays;
        }

        public var bundlePurchaseAllowed(get,never):Bool;
public function  get_bundlePurchaseAllowed():Bool
        {
            return false;
        }

        public var isRentOffer(get,never):Bool;
public function  get_isRentOffer():Bool
        {
            return false;
        }

        public var giftable(get,never):Bool;
public function  get_giftable():Bool
        {
            return this._giftable;
        }

        public var pricingModel(get,never):String;
public function  get_pricingModel():String
        {
            return "";
        }

        
        public var previewCallbackId(get,set):Int;
public function  set_previewCallbackId(k:Int):Int        {
return k;
        }
public function  get_previewCallbackId():Int
        {
            return 0;
        }

        public var clubLevel(get,never):Int;
public function  get_clubLevel():Int
        {
            return 0;
        }

        public var badgeCode(get,never):String;
public function  get_badgeCode():String
        {
            return "";
        }

        public var localizationName(get,never):String;
public function  get_localizationName():String
        {
            return ("${" + this.localizationId) + "}";
        }

        public var localizationDescription(get,never):String;
public function  get_localizationDescription():String
        {
            return ("${" + this.localizationId) + "}";
        }
    }

