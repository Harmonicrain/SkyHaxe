package com.sulake.habbo.catalog.viewer
;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.habbo.session.product.IProductData;
    import com.sulake.habbo.session.furniture.IFurnitureData;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import com.sulake.habbo.session.events.BadgeImageReadyEvent;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.room.ImageResult;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import com.sulake.habbo.catalog.viewer.widgets.BundleGridViewCatalogWidget;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.IWindowContainer;

     class Product extends ProductGridItem implements IProduct implements  IGetImageListener 
    {
        public static inline final _Str_10915= 108;

        var _productType:String;
        var _productClassId:Int = 0;
        var _extraParam:String;
        var _productCount:Int = 0;
        var _productData:IProductData;
        var _furnitureData:IFurnitureData;
        var _isUniqueLimitedItem:Bool = false;
        var _uniqueLimitedItemSeriesSize:Int = 0;
        var _uniqueLimitedItemsLeft:Int = 0;
        var _productContainer:IProductContainer;

        public function new(k:String, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:IProductData, _arg_6:IFurnitureData, _arg_7:HabboCatalog, _arg_8:Bool=false, _arg_9:Int=0, _arg_10:Int=0)
        {
            super(_arg_7);
            this._productType = k;
            this._productClassId = _arg_2;
            this._extraParam = _arg_3;
            this._productCount = _arg_4;
            this._productData = _arg_5;
            this._furnitureData = _arg_6;
            this._isUniqueLimitedItem = _arg_8;
            this._uniqueLimitedItemSeriesSize = _arg_9;
            this._uniqueLimitedItemsLeft = _arg_10;
        }

        public static function _Str_21036(k:Vector<IProduct>):Vector<IProduct>
        {
            var _local_3:Product = null;
            if (k.length == 1)
            {
                return k;
            }
            var _local_2= new Vector<IProduct>(0);
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = cast(_tmp_, Product);
                if ((((!(_local_3.productType == ProductTypeEnum.BADGE)) && (!(_local_3.productType == ProductTypeEnum.CHAT_STYLE))) && (!((_local_3.productType == ProductTypeEnum.EFFECT) && (_local_3.productClassId == _Str_10915)))))
                {
                    _local_2.push(_local_3);
                }
            }
            return _local_2;
        }


        public var productType(get,never):String;
public function  get_productType():String
        {
            return this._productType;
        }

        public var productClassId(get,never):Int;
public function  get_productClassId():Int
        {
            return this._productClassId;
        }

        
        public var extraParam(get,set):String;
public function  set_extraParam(k:String):String        {
            return this._extraParam = k;
        }
public function  get_extraParam():String
        {
            return this._extraParam;
        }

        public var productCount(get,never):Int;
public function  get_productCount():Int
        {
            return this._productCount;
        }

        public var productData(get,never):IProductData;
public function  get_productData():IProductData
        {
            return this._productData;
        }

        public var furnitureData(get,never):IFurnitureData;
public function  get_furnitureData():IFurnitureData
        {
            return this._furnitureData;
        }

        public var isUniqueLimitedItem(get,never):Bool;
public function  get_isUniqueLimitedItem():Bool
        {
            return this._isUniqueLimitedItem;
        }

        public var uniqueLimitedItemSeriesSize(get,never):Int;
public function  get_uniqueLimitedItemSeriesSize():Int
        {
            return this._uniqueLimitedItemSeriesSize;
        }

        
        public var uniqueLimitedItemsLeft(get,set):Int;
public function  get_uniqueLimitedItemsLeft():Int
        {
            return this._uniqueLimitedItemsLeft;
        }
public function  set_uniqueLimitedItemsLeft(uniqueLimitedItemsLeft:Int):Int        {
            return this._uniqueLimitedItemsLeft = uniqueLimitedItemsLeft;
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            this._productType = "";
            this._productClassId = 0;
            this._extraParam = "";
            this._productCount = 0;
            this._productData = null;
            this._furnitureData = null;
            if (((catalog != null) && (catalog.sessionDataManager != null)))
            {
                catalog.sessionDataManager.events.removeEventListener(BadgeImageReadyEvent.BIRE_BADGE_IMAGE_READY, this.onBadgeImageReady);
            }
            super.dispose();
        }

        public function initIcon(k:IProductContainer, _arg_2:IGetImageListener=null, _arg_3:IAvatarImageListener=null, _arg_4:IPurchasableOffer=null, _arg_5:IBitmapWrapperWindow=null, _arg_6:IStuffData=null, _arg_7:ASFunction=null):BitmapData
        {
            var _local_9:IRoomEngine = null;
            var _local_10:ImageResult = null;
            var _local_11:String = null;
            if (disposed)
            {
                return null;
            }
            var _local_8:BitmapData = null;
            if (_arg_2 == null)
            {
                _arg_2 = this;
            }
            if (Std.is(k , BundleGridViewCatalogWidget))
            {
                _local_9 = Std.downcast(k , BundleGridViewCatalogWidget).offer.page.viewer.roomEngine;
            }
            else
            {
                _local_9 = Std.downcast(k , ProductContainer).offer.page.viewer.roomEngine;
            }
            if (((!(_local_9 != null)) || (!(catalog != null))))
            {
                return null;
            }
            switch (this._productType)
            {
                case ProductTypeEnum.FLOOR:
                    _local_10 = _local_9.getFurnitureIcon(this.productClassId, _arg_2, null, _arg_6);
                    
                case ProductTypeEnum.WALL:
                    if (((_arg_4 != null) && (this._furnitureData != null)))
                    {
                        _local_11 = "";
                        switch (this._furnitureData.className)
                        {
                            case "floor":
                                _local_11 = (["th", this._furnitureData.className, _arg_4.product.extraParam] : Array<Dynamic>).join("_");
                                
                            case "wallpaper":
                                _local_11 = (["th", "wall", _arg_4.product.extraParam] : Array<Dynamic>).join("_");
                                
                            case "landscape":
                                _local_11 = (["th", this._furnitureData.className, ASCompat.stringReplace(_arg_4.product.extraParam, ".", "_"), "001"] : Array<Dynamic>).join("_");
                                
                            default:
                                _local_10 = _local_9.getWallItemIcon(this.productClassId, _arg_2, this._extraParam);
                        }
                        catalog.setImageFromAsset(_arg_5, _local_11, _arg_7);
                    }
                    else
                    {
                        _local_10 = _local_9.getWallItemIcon(this.productClassId, _arg_2, this._extraParam);
                    }
                    
                case ProductTypeEnum.EFFECT:
                    _local_8 = catalog.getPixelEffectIcon(this.productClassId);
                    if ((_arg_2 : ASAny) == (this : ASAny))
                    {
                        this.setIconImage(_local_8, true);
                    }
                    
                case ProductTypeEnum.HABBO_CLUB:
                    _local_8 = catalog.getSubscriptionProductIcon(this.productClassId);
                    
                case ProductTypeEnum.BADGE:
                    catalog.sessionDataManager.events.addEventListener(BadgeImageReadyEvent.BIRE_BADGE_IMAGE_READY, this.onBadgeImageReady);
                    _local_8 = catalog.sessionDataManager.getBadgeImage(this._extraParam);
                    this._productContainer = k;
                    
                case ProductTypeEnum.CHAT_STYLE:
                    _local_8 = catalog.createChatStylePreview(ASCompat.parseInt(this._extraParam));
                    if (_local_8 != null)
                    {
                        _local_8 = this._Str_scaleChatStyleIcon(_local_8);
                    }
                    if ((_arg_2 : ASAny) == (this : ASAny))
                    {
                        this.setIconImage(_local_8, true);
                    }
                    
                case ProductTypeEnum.ROBOT:
                    _local_8 = _Str_12672(this._extraParam, _arg_3);
                    setIconImage(_local_8, false);
                    
                default:
                    Logger.log([("[Product] Can not yet handle this type of product: " + this.productType)]);
            }
            if (_local_10 != null)
            {
                _local_8 = _local_10.data;
                if ((_arg_2 : ASAny) == (this : ASAny))
                {
                    this.setIconImage(_local_8, true);
                }
            }
            return _local_8;
        }

        function _Str_scaleChatStyleIcon(k:BitmapData):BitmapData
        {
            var _local_2= Std.int(Math.max(1, (k.width / 2)));
            var _local_3= Std.int(Math.max(1, (k.height / 2)));
            var _local_4= new BitmapData(_local_2, _local_3, true, 0);
            _local_4.draw(k, new Matrix(0.5, 0, 0, 0.5), null, null, null, true);
            return _local_4;
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            if (!disposed)
            {
                setIconImage(_arg_2, true);
            }
        }

        public function imageFailed(k:Int)
        {
        }

        function onBadgeImageReady(k:BadgeImageReadyEvent)
        {
            if (!disposed)
            {
                if (((this._productType == ProductTypeEnum.BADGE) && (k.badgeId == this._extraParam)))
                {
                    cast(this._productContainer, ProductGridItem).setIconImage(k.badgeImage, false);
                    if (((catalog != null) && (catalog.sessionDataManager != null)))
                    {
                        catalog.sessionDataManager.events.removeEventListener(BadgeImageReadyEvent.BIRE_BADGE_IMAGE_READY, this.onBadgeImageReady);
                    }
                }
            }
        }

        public var isColorable(get,never):Bool;
public function  get_isColorable():Bool
        {
            if (((this._furnitureData != null) && ASCompat.stringAsBool(this._furnitureData.fullName)))
            {
                return !(this._furnitureData.fullName.indexOf("*") == -1);
            }
            return false;
        }

        override public function  set_view(k:IWindowContainer):IWindowContainer        {
            var _local_2:IWindow = null;
            var _local_3:ITextWindow = null;
            if (k == null)
            {
                return k;
            }
            super.view = k;
            if (this._productCount > 1)
            {
                _local_2 = _view.findChildByName("multiContainer");
                if (_local_2 != null)
                {
                    _local_2.visible = true;
                }
                _local_3 = Std.downcast(_view.findChildByName("multiCounter") , ITextWindow);
                if (_local_3 != null)
                {
                    _local_3.text = ("x" + Std.string(this.productCount));
                }
            }
return k;
        }
    }

