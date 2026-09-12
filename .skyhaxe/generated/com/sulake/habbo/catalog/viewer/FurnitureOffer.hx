package com.sulake.habbo.catalog.viewer
;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.catalog.HabboCatalog;

     class FurnitureOffer implements IPurchasableOffer 
    {
        var _furniData:IFurnitureData;
        var _previewCallbackId:Int = 0;
        var _page:ICatalogPage;
        var _productContainer:FurniProductContainer;
        var _product:Product;

        public function new(k:IFurnitureData, _arg_2:HabboCatalog)
        {
            this._furniData = k;
            this._productContainer = new FurniProductContainer(this, new Vector<IProduct>(0), _arg_2, this._furniData);
            this._product = new Product(this._furniData.type, this._furniData.id, this._furniData.customParams, 1, _arg_2.getProductData(this._furniData.className), this._furniData, _arg_2);
        }

        public function dispose()
        {
            this._furniData = null;
            this._page = null;
            this._previewCallbackId = -1;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._furniData == null;
        }

        public var offerId(get,never):Int;
public function  get_offerId():Int
        {
            return this.isRentOffer ? this._furniData.rentOfferId : this._furniData.purchaseOfferId;
        }

        public var priceInActivityPoints(get,never):Int;
public function  get_priceInActivityPoints():Int
        {
            return 0;
        }

        public var activityPointType(get,never):Int;
public function  get_activityPointType():Int
        {
            return 0;
        }

        public var priceInCredits(get,never):Int;
public function  get_priceInCredits():Int
        {
            return 0;
        }

        
        public var page(get,set):ICatalogPage;
public function  get_page():ICatalogPage
        {
            return this._page;
        }

        public var priceType(get,never):String;
public function  get_priceType():String
        {
            return "";
        }

        public var productContainer(get,never):IProductContainer;
public function  get_productContainer():IProductContainer
        {
            return this._productContainer;
        }

        public var product(get,never):IProduct;
public function  get_product():IProduct
        {
            return this._product;
        }

        public var gridItem(get,never):IGridItem;
public function  get_gridItem():IGridItem
        {
            return this._productContainer ;
        }

        public var localizationId(get,never):String;
public function  get_localizationId():String
        {
            return "roomItem.name." + Std.string(this._furniData.id);
        }

        public var bundlePurchaseAllowed(get,never):Bool;
public function  get_bundlePurchaseAllowed():Bool
        {
            return false;
        }

        public var isRentOffer(get,never):Bool;
public function  get_isRentOffer():Bool
        {
            return (this._furniData.rentOfferId > -1) && (!((!(this._page == null)) && this._page._Str_21286));
        }

        public var giftable(get,never):Bool;
public function  get_giftable():Bool
        {
            return false;
        }

        public var pricingModel(get,never):String;
public function  get_pricingModel():String
        {
            return Offer.PRICING_MODEL_FURNITURE;
        }

        
        public var previewCallbackId(get,set):Int;
public function  set_previewCallbackId(k:Int):Int        {
            return this._previewCallbackId = k;
        }
public function  get_previewCallbackId():Int
        {
            return this._previewCallbackId;
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
public function  set_page(k:ICatalogPage):ICatalogPage        {
            return this._page = k;
        }

        public var localizationName(get,never):String;
public function  get_localizationName():String
        {
            return this._furniData.localizedName;
        }

        public var localizationDescription(get,never):String;
public function  get_localizationDescription():String
        {
            return this._furniData.description;
        }
    }

