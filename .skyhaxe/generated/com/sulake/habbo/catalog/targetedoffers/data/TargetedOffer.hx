package com.sulake.habbo.catalog.targetedoffers.data
;
    import com.sulake.habbo.communication.messages.incoming.catalog.TargetedOfferData;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.habbo.catalog.viewer.ICatalogPage;
    import com.sulake.habbo.catalog.viewer.IProduct;
    import com.sulake.habbo.catalog.viewer.IProductContainer;
    import com.sulake.habbo.catalog.viewer.IGridItem;
    import com.sulake.habbo.catalog.purse.IPurse;
    import com.sulake.habbo.session.product.IProductData;
    import com.sulake.habbo.catalog.IHabboCatalog;

     class TargetedOffer extends TargetedOfferData implements IPurchasableOffer 
    {
        public static inline final _Str_16647= 10;

        public function new(k:TargetedOfferData=null)
        {
            super(k);
        }

        public var offerId(get,never):Int;
public function  get_offerId():Int
        {
            return 0;
        }

        
        public var page(get,set):ICatalogPage;
public function  get_page():ICatalogPage
        {
            return null;
        }
public function  set_page(k:ICatalogPage):ICatalogPage        {
return k;
        }

        public var priceType(get,never):String;
public function  get_priceType():String
        {
            return "";
        }

        public var product(get,never):IProduct;
public function  get_product():IProduct
        {
            return null;
        }

        public var productContainer(get,never):IProductContainer;
public function  get_productContainer():IProductContainer
        {
            return null;
        }

        public var gridItem(get,never):IGridItem;
public function  get_gridItem():IGridItem
        {
            return null;
        }

        public var localizationId(get,never):String;
public function  get_localizationId():String
        {
            return "";
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
            return false;
        }

        public var pricingModel(get,never):String;
public function  get_pricingModel():String
        {
            return "";
        }

        
        public var previewCallbackId(get,set):Int;
public function  get_previewCallbackId():Int
        {
            return 0;
        }
public function  set_previewCallbackId(k:Int):Int        {
return k;
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
            return "";
        }

        public var localizationDescription(get,never):String;
public function  get_localizationDescription():String
        {
            return "";
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return false;
        }

        public function isExpired():Bool
        {
            return (_expirationTime > 0) && (this._Str_18165() <= 0);
        }

        public function _Str_18165():Int
        {
            var k:UInt = Std.int(((_expirationTime - flash.Lib.getTimer()) / 1000) - _Str_16647);
            return Std.int(Math.max(0, k));
        }

        public function checkPurseBalance(k:IPurse, _arg_2:Int):Bool
        {
            if (((!(k != null)) || (k.credits < (_Str_3594 * _arg_2))))
            {
                return false;
            }
            if (k.getActivityPointsForType(_Str_2956) < (_Str_3539 * _arg_2))
            {
                return false;
            }
            return true;
        }

        public function _Str_26048(k:IHabboCatalog):Vector<String>
        {
            var _local_3:String = null;
            var _local_4:IProductData = null;
            var _local_2= new Vector<String>(0);
            final _iter_ = _Str_11962; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = _tmp_;
                _local_4 = k.getProductData(_local_3);
                _local_2.push(((_local_4 != null) ? _local_4.name : _local_3));
            }
            return _local_2;
        }

        public function dispose()
        {
        }
    }

