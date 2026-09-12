package com.sulake.habbo.catalog.viewer
;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.display.BitmapData;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.session.HabboClubLevelEnum;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.habbo.catalog.purse.ActivityPointTypeEnum;
    import com.sulake.core.window.components.IItemListWindow;

     class ProductContainer extends ProductGridItem implements IGetImageListener implements  IProductContainer implements  IGridItem implements  IAvatarImageListener 
    {
        static inline final TOTALPRICE_CONTAINER= "totalprice_container";
        static inline final AMOUNT_TEXT_LEFT= "amount_text_left";
        static inline final AMOUNT_TEXT_RIGHT= "amount_text_right";
        static inline final CURRENCY_INDICATOR_RIGHT= "currency_indicator_bitmap_right";

        var _offer:IPurchasableOffer;
        var _products:Vector<IProduct>;

        public function new(k:IPurchasableOffer, _arg_2:Vector<IProduct>, _arg_3:HabboCatalog)
        {
            var _local_4:String = null;
            var _local_5:Product = null;
            super(_arg_3);
            if (checkNullIteratee(_arg_2)) for (_tmp_ in _arg_2)
            {
_local_5  = cast(_tmp_, Product);
                if (_local_5.productType != ProductTypeEnum.BADGE)
                {
                    _local_4 = _local_5.extraParam;
                    break;
                }
            }
            this._offer = k;
            this._products = _arg_2;
        }

        public var products(get,never):Vector<IProduct>;
public function  get_products():Vector<IProduct>
        {
            return this._products;
        }

        public var _Str_6851(get,never):IProduct;
public function  get__Str_6851():IProduct
        {
            if (((!(this._products != null)) || (this._products.length == 0)))
            {
                return null;
            }
            if (this._products.length == 1)
            {
                return this._products[0];
            }
            var k= Product._Str_21036(this._products);
            return (k.length > 0) ? k[0] : null;
        }

        public var offer(get,never):IPurchasableOffer;
public function  get_offer():IPurchasableOffer
        {
            return this._offer;
        }

        override public function dispose()
        {
            var k:Product = null;
            if (disposed)
            {
                return;
            }
            final _iter_ = this._products; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
k  = cast(_tmp_, Product);
                k.dispose();
            }
            this._products = null;
            super.dispose();
        }

        public var isLazy(get,never):Bool;
public function  get_isLazy():Bool
        {
            return false;
        }

        public function initProductIcon(k:IRoomEngine, _arg_2:IStuffData=null)
        {
        }

        override public function  set_view(k:IWindowContainer):IWindowContainer        {
            var _local_2 = 0;
            var _local_3:IProduct = null;
            super.view = k;
            if (_view == null)
            {
                return k;
            }
            if (((((catalog != null) && ASCompat.stringAsBool(this._offer.badgeCode)) && (!(this._offer.badgeCode == ""))) && (this._offer.productContainer.products.length > 1)))
            {
                this._Str_20490("catalog_icon_badge_included");
            }
            else
            {
                if (((catalog != null) && (this._offer.productContainer.products.length == 2)))
                {
                    _local_2 = 0;
                    while (_local_2 < 2)
                    {
                        _local_3 = this._offer.productContainer.products[_local_2];
                        if (((_local_3.productType == ProductTypeEnum.EFFECT) && (_local_3.productClassId == Product._Str_10915)))
                        {
                            this._Str_20490("catalog_icon_ninja_effect_included");
                        }
                        _local_2++;
                    }
                }
            }
            this._Str_15497(this.offer.clubLevel);
            if (catalog.isDraggable(this.offer))
            {
                _Str_16497(true);
            }
return k;
        }

        function _Str_20490(k:String)
        {
            var _local_2= Std.downcast(_view.findChildByName("badge_add_on") , IBitmapWrapperWindow);
            var _local_3= catalog.assets.getAssetByName(k);
            _local_2.bitmap = ASCompat.dynamicAs(_local_3.content , BitmapData);
            var _local_4= ASCompat.dynamicAs(_local_3.content , BitmapData);
            _local_2.width = _local_4.width;
            _local_2.height = _local_4.height;
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            setIconImage(_arg_2, true);
        }

        public function imageFailed(k:Int)
        {
        }

        public function _Str_15497(k:Int)
        {
            if (view == null)
            {
                return;
            }
            var _local_2= view.findChildByName("clubLevelIcon");
            if (_local_2 == null)
            {
                return;
            }
            switch (this.offer.clubLevel)
            {
                case HabboClubLevelEnum.NO_CLUB:
                    _local_2.visible = false;
                    return;
                case HabboClubLevelEnum.CLUB:
                    _local_2.visible = true;
                    _local_2.style = 11;
                    _local_2.x = (_local_2.x + 3);
                    return;
                case HabboClubLevelEnum.VIP:
                    _local_2.visible = true;
                    _local_2.style = 12;
                    return;
            }
        }

        public function avatarImageReady(k:String)
        {
            var _local_2:IProduct = null;
            if (!disposed)
            {
                final _iter_ = this.products; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_2  = _tmp_;
                    if (((_local_2.productType == ProductTypeEnum.ROBOT) && (_local_2.extraParam == k)))
                    {
                        setIconImage(_Str_12672(_local_2.extraParam, this), true);
                        return;
                    }
                }
            }
        }

        public function _Str_18628(k:HabboCatalog)
        {
            var _local_3:ITextWindow = null;
            var _local_4:ITextWindow = null;
            var _local_5:IWindow = null;
            if (this._offer.priceInCredits > 0)
            {
                if (this._offer.priceInActivityPoints > 0)
                {
                    _local_3 = cast(_view.findChildByName(AMOUNT_TEXT_LEFT), ITextWindow);
                }
                else
                {
                    _local_3 = cast(_view.findChildByName(AMOUNT_TEXT_RIGHT), ITextWindow);
                }
                if (_local_3 != null)
                {
                    _local_3.text = (Std.string(this._offer.priceInCredits) + "");
                }
            }
            if (this._offer.priceInActivityPoints > 0)
            {
                _local_4 = cast(_view.findChildByName(AMOUNT_TEXT_RIGHT), ITextWindow);
                if (_local_4 != null)
                {
                    _local_5 = _view.findChildByName(CURRENCY_INDICATOR_RIGHT);
                    if (_local_5 != null)
                    {
                        _local_5.style = ActivityPointTypeEnum.getIconStyleFor(this._offer.activityPointType, k, false);
                    }
                    _local_4.text = (Std.string(this._offer.priceInActivityPoints) + "");
                }
            }
            var _local_2= cast(_view.findChildByName(TOTALPRICE_CONTAINER), IItemListWindow);
            if (_local_2 != null)
            {
                _local_2.arrangeListItems();
            }
        }
    }

