package com.sulake.habbo.catalog.viewer
;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import com.sulake.habbo.session.furniture.IFurnitureData;

     class Offer implements IPurchasableOffer 
    {
        public static inline final PRICING_MODEL_UNKNOWN= "pricing_model_unknown";
        public static inline final PRICING_MODEL_SINGLE= "pricing_model_single";
        public static inline final PRICING_MODEL_MULTI= "pricing_model_multi";
        public static inline final PRICING_MODEL_BUNDLE= "pricing_model_bundle";
        public static inline final PRICING_MODEL_FURNITURE= "pricing_model_furniture";
        public static inline final PRICE_TYPE_NONE= "price_type_none";
        public static inline final PRICE_TYPE_CREDITS= "price_type_credits";
        public static inline final PRICE_TYPE_ACTIVITYPOINTS= "price_type_activitypoints";
        public static inline final PRICE_TYPE_CREDITS_ACTIVITYPOINTS= "price_type_credits_and_activitypoints";

        var _pricingModel:String;
        var _priceType:String;
        var _offerId:Int = 0;
        var _localizationId:String;
        var _priceInCredits:Int = 0;
        var _priceInActivityPoints:Int = 0;
        var _activityPointType:Int = 0;
        var _giftable:Bool = false;
        var _isRentOffer:Bool = false;
        var _page:ICatalogPage;
        var _productContainer:IProductContainer;
        var _disposed:Bool = false;
        var _clubLevel:Int = 0;
        var _badgeCode:String;
        var _bundlePurchaseAllowed:Bool = false;
        var _catalog:HabboCatalog;
        var _previewCallbackId:Int = 0;

        public function new(k:Int, _arg_2:String, _arg_3:Bool, _arg_4:Int, _arg_5:Int, _arg_6:Int, _arg_7:Bool, _arg_8:Int, _arg_9:Vector<IProduct>, _arg_10:Bool, _arg_11:HabboCatalog)
        {
            var _local_12:Product = null;
            this._offerId = k;
            this._localizationId = _arg_2;
            this._isRentOffer = _arg_3;
            this._priceInCredits = _arg_4;
            this._priceInActivityPoints = _arg_5;
            this._activityPointType = _arg_6;
            this._giftable = _arg_7;
            this._clubLevel = _arg_8;
            this._bundlePurchaseAllowed = _arg_10;
            this._catalog = _arg_11;
            this._Str_22470(_arg_9);
            this._Str_25477();
            this._Str_23871(_arg_9);
            if (checkNullIteratee(_arg_9)) for (_tmp_ in _arg_9)
            {
_local_12  = cast(_tmp_, Product);
                if (_local_12.productType == ProductTypeEnum.BADGE)
                {
                    this._badgeCode = _local_12.extraParam;
                    break;
                }
            }
        }

        public var clubLevel(get,never):Int;
public function  get_clubLevel():Int
        {
            return this._clubLevel;
        }

        
        public var page(get,set):ICatalogPage;
public function  get_page():ICatalogPage
        {
            return this._page;
        }
public function  set_page(k:ICatalogPage):ICatalogPage        {
            return this._page = k;
        }

        public var offerId(get,never):Int;
public function  get_offerId():Int
        {
            return this._offerId;
        }

        public var localizationId(get,never):String;
public function  get_localizationId():String
        {
            return this._localizationId;
        }

        public var priceInCredits(get,never):Int;
public function  get_priceInCredits():Int
        {
            return this._priceInCredits;
        }

        public var priceInActivityPoints(get,never):Int;
public function  get_priceInActivityPoints():Int
        {
            return this._priceInActivityPoints;
        }

        public var activityPointType(get,never):Int;
public function  get_activityPointType():Int
        {
            return this._activityPointType;
        }

        public var giftable(get,never):Bool;
public function  get_giftable():Bool
        {
            return this._giftable;
        }

        public var productContainer(get,never):IProductContainer;
public function  get_productContainer():IProductContainer
        {
            return this._productContainer;
        }

        public var product(get,never):IProduct;
public function  get_product():IProduct
        {
            return (this._productContainer != null) ? this._productContainer._Str_6851 : null;
        }

        public var gridItem(get,never):IGridItem;
public function  get_gridItem():IGridItem
        {
            return ASCompat.reinterpretAs(this._productContainer , IGridItem);
        }

        public var pricingModel(get,never):String;
public function  get_pricingModel():String
        {
            return this._pricingModel;
        }

        public var priceType(get,never):String;
public function  get_priceType():String
        {
            return this._priceType;
        }

        
        public var previewCallbackId(get,set):Int;
public function  get_previewCallbackId():Int
        {
            return this._previewCallbackId;
        }
public function  set_previewCallbackId(k:Int):Int        {
            return this._previewCallbackId = k;
        }

        public var bundlePurchaseAllowed(get,never):Bool;
public function  get_bundlePurchaseAllowed():Bool
        {
            return this._bundlePurchaseAllowed;
        }

        public var isRentOffer(get,never):Bool;
public function  get_isRentOffer():Bool
        {
            return this._isRentOffer;
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            this._disposed = true;
            this._offerId = 0;
            this._localizationId = "";
            this._priceInCredits = 0;
            this._priceInActivityPoints = 0;
            this._activityPointType = 0;
            this._page = null;
            this._catalog = null;
            if (this._productContainer != null)
            {
                this._productContainer.dispose();
                this._productContainer = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function _Str_23871(k:Vector<IProduct>)
        {
            switch (this._pricingModel)
            {
                case PRICING_MODEL_SINGLE:
                    this._productContainer = new SingleProductContainer(this, k, this._catalog);
                    return;
                case PRICING_MODEL_MULTI:
                    this._productContainer = new MultiProductContainer(this, k, this._catalog);
                    return;
                case PRICING_MODEL_BUNDLE:
                    this._productContainer = new BundleProductContainer(this, k, this._catalog);
                    return;
                default:
                    this._productContainer = new ProductContainer(this, k, this._catalog);
                    Logger.log([("[Offer] Unknown pricing model" + this._pricingModel)]);
            }
        }

        function _Str_22470(k:Vector<IProduct>)
        {
            var _local_2= Product._Str_21036(k);
            if (_local_2.length == 1)
            {
                if (_local_2[0].productCount == 1)
                {
                    this._pricingModel = PRICING_MODEL_SINGLE;
                }
                else
                {
                    this._pricingModel = PRICING_MODEL_MULTI;
                }
            }
            else
            {
                if (_local_2.length > 1)
                {
                    this._pricingModel = PRICING_MODEL_BUNDLE;
                }
                else
                {
                    this._pricingModel = PRICING_MODEL_UNKNOWN;
                }
            }
        }

        function _Str_25477()
        {
            if (((this._priceInCredits > 0) && (this._priceInActivityPoints > 0)))
            {
                this._priceType = PRICE_TYPE_CREDITS_ACTIVITYPOINTS;
            }
            else
            {
                if (this._priceInCredits > 0)
                {
                    this._priceType = PRICE_TYPE_CREDITS;
                }
                else
                {
                    if (this._priceInActivityPoints > 0)
                    {
                        this._priceType = PRICE_TYPE_ACTIVITYPOINTS;
                    }
                    else
                    {
                        this._priceType = PRICE_TYPE_NONE;
                    }
                }
            }
        }

        public function clone():Offer
        {
            var _local_3:IProduct = null;
            var _local_4:Offer = null;
            var _local_5:IFurnitureData = null;
            var _local_6:Product = null;
            var k= new Vector<IProduct>(0);
            var _local_2= this._catalog.getProductData(this.localizationId);
            final _iter_ = this._productContainer.products; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_5 = this._catalog.getFurnitureData(_local_3.productClassId, _local_3.productType);
                _local_6 = new Product(_local_3.productType, _local_3.productClassId, _local_3.extraParam, _local_3.productCount, _local_2, _local_5, this._catalog);
                k.push(_local_6);
            }
            _local_4 = new Offer(this.offerId, this.localizationId, this.isRentOffer, this.priceInCredits, this.priceInActivityPoints, this.activityPointType, this.giftable, this.clubLevel, k, this.bundlePurchaseAllowed, this._catalog);
            _local_4.page = this.page;
            return _local_4;
        }

        public var badgeCode(get,never):String;
public function  get_badgeCode():String
        {
            return this._badgeCode;
        }

        public var localizationName(get,never):String;
public function  get_localizationName():String
        {
            var k= this._catalog.getProductData(this._localizationId);
            return (k != null) ? k.name : (("${" + this._localizationId) + "}");
        }

        public var localizationDescription(get,never):String;
public function  get_localizationDescription():String
        {
            var k= this._catalog.getProductData(this._localizationId);
            return (k != null) ? k.description : (("${" + this._localizationId) + "}");
        }
    }

