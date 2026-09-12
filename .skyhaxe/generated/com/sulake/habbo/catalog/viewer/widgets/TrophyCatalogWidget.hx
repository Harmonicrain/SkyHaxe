package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.habbo.room.IGetImageListener;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetEvent;
    import com.sulake.core.window.components.IContainerButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.catalog.viewer.Offer;
    import com.sulake.habbo.catalog.viewer.widgets.events.SelectProductEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetColoursEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events._Str_3308;
    import flash.display.BitmapData;
    import com.sulake.habbo.catalog.viewer.IProduct;
    import com.sulake.habbo.room.ImageResult;
    import com.sulake.habbo.catalog.viewer.ProductImageConfiguration;
    import com.sulake.room.utils.Vector3d;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetColourIndexEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.SetExtraPurchaseParameterEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.TextInputEvent;
    import flash.geom.Point;
    import com.sulake.core.assets.BitmapDataAsset;
    import flash.net.URLRequest;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;

     class TrophyCatalogWidget extends CatalogWidget implements IGetImageListener 
    {
        static inline final gold= 0xFFCC00;
        static inline final silver= 0xCCCCCC;
        static inline final _Str_16105= 0xCC6600;

        var _previewImage:IBitmapWrapperWindow;
        var _trophyOffers:Map;
        var _selectIndex:Int = 0;
        var _selectType:String = "g";
        var _catalog:HabboCatalog;
        var _priceWidget:IWindow;

        public function new(k:IWindowContainer, _arg_2:HabboCatalog)
        {
            super(k);
            this._catalog = _arg_2;
        }

        override public function dispose()
        {
            if (this._trophyOffers != null)
            {
                this._trophyOffers.dispose();
            }
            this._trophyOffers = null;
            this._catalog = null;
            this._priceWidget = null;
            super.dispose();
        }

        override public function init():Bool
        {
            var _local_4:String = null;
            var _local_5:String = null;
            var _local_6:Map = null;
            var _local_7:IWindowContainer = null;
            if (!super.init())
            {
                return false;
            }
            this._previewImage = Std.downcast(window.findChildByName("ctlg_teaserimg_1") , IBitmapWrapperWindow);
            events.addEventListener(CatalogWidgetEvent.SELECT_PRODUCT, this.onSelectProduct);
            events.addEventListener(CatalogWidgetEvent.COLOUR_INDEX, this._Str_7756);
            events.addEventListener(CatalogWidgetEvent.TEXT_INPUT, this._Str_25854);
            var k= Std.downcast(window.findChildByName("ctlg_nextmodel_button") , IContainerButtonWindow);
            var _local_2= Std.downcast(window.findChildByName("ctlg_prevmodel_button") , IContainerButtonWindow);
            if (k != null)
            {
                k.addEventListener(WindowMouseEvent.CLICK, this._Str_23372);
            }
            if (_local_2 != null)
            {
                _local_2.addEventListener(WindowMouseEvent.CLICK, this._Str_25780);
            }
            this._trophyOffers = new Map();
            var _local_3:Offer = null;
            final _iter_ = page.offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = cast(_tmp_, Offer);
                _local_4 = this._Str_23368(_local_3.localizationId);
                _local_5 = this._Str_19039(_local_3.localizationId);
                if (this._trophyOffers.getValue(_local_4) == null)
                {
                    this._trophyOffers.add(_local_4, new Map());
                }
                _local_6 = ASCompat.dynamicAs(this._trophyOffers.getValue(_local_4) , Map);
                _local_6.add(_local_5, _local_3);
            }
            if (page.offers.length == 1)
            {
                k.visible = (_local_2.visible = false);
                if (page.offers[0].product.isColorable == false)
                {
                    if (cast(window.parent, IWindowContainer) != null)
                    {
                        _local_7 = Std.downcast(cast(window.parent, IWindowContainer).findChildByName("colourGridWidget") , IWindowContainer);
                        if (_local_7 != null)
                        {
                            _local_7.visible = false;
                        }
                    }
                }
            }
            events.addEventListener(CatalogWidgetEvent.WIDGETS_INITIALIZED, this.onWidgetsInitialized);
            return true;
        }

        function onWidgetsInitialized(k:_Str_3308)
        {
            var _local_4:Offer = null;
            var _local_2= new Array<ASAny>();
            _local_2.push(gold);
            _local_2.push(silver);
            _local_2.push(_Str_16105);
            var _local_3:Map = this._trophyOffers.getWithIndex(this._selectIndex);
            if (_local_3 != null)
            {
                _local_4 = _local_3.getValue(this._selectType);
                if (_local_4 == null)
                {
                    _local_4 = _local_3.getWithIndex(0);
                }
                if (_local_4 != null)
                {
                    events.dispatchEvent(new SelectProductEvent(_local_4));
                }
            }
            events.dispatchEvent(new CatalogWidgetColoursEvent(_local_2, "ctlg_clr_40x32_1", "ctlg_clr_40x32_2", "ctlg_clr_40x32_3"));
        }

        function onSelectProduct(k:SelectProductEvent)
        {
            var _local_4:BitmapData = null;
            var _local_5:IProduct = null;
            var _local_6:ImageResult = null;
            if (k == null)
            {
                return;
            }
            var _local_2= k.offer;
            var _local_3= page.viewer.catalog.getProductData(_local_2.localizationId);
            if (ProductImageConfiguration.hasProductImage(_local_2.localizationId))
            {
                this._Str_6504(ProductImageConfiguration.PRODUCT_IMAGES[_local_2.localizationId]);
            }
            else
            {
                _local_5 = _local_2.product;
                _local_6 = page.viewer.roomEngine.getFurnitureImage(_local_5.productClassId, new Vector3d(2, 0, 0), 64, this, 0, _local_5.extraParam);
                _local_2.previewCallbackId = _local_6.id;
                if (_local_6 != null)
                {
                    _local_4 = _local_6.data;
                }
                this._Str_3234(_local_4, true);
            }
            this._priceWidget = this._catalog.utils._Str_7075(_local_2, _window, this._priceWidget, this._previewImage, 0, false, 0);
        }

        function _Str_7756(k:CatalogWidgetColourIndexEvent)
        {
            var _local_3:Offer = null;
            if (k.index == 0)
            {
                this._selectType = "g";
            }
            if (k.index == 1)
            {
                this._selectType = "s";
            }
            if (k.index == 2)
            {
                this._selectType = "b";
            }
            var _local_2:Map = this._trophyOffers.getWithIndex(this._selectIndex);
            if (_local_2 != null)
            {
                _local_3 = _local_2.getValue(this._selectType);
                if (_local_3 == null)
                {
                    _local_3 = _local_2.getWithIndex(0);
                }
                if (_local_3 != null)
                {
                    events.dispatchEvent(new SelectProductEvent(_local_3));
                }
            }
            this._priceWidget = this._catalog.utils._Str_7075(_local_3, _window, this._priceWidget, this._previewImage, 0, false, 0);
        }

        public function _Str_25854(k:TextInputEvent)
        {
            events.dispatchEvent(new SetExtraPurchaseParameterEvent(k.text));
        }

        public function imageReady(k:Int, _arg_2:BitmapData)
        {
            var _local_3:Offer = null;
            if (((disposed || (page == null)) || (page.offers == null)))
            {
                return;
            }
            final _iter_ = page.offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_3  = cast(_tmp_, Offer);
                if (_local_3.previewCallbackId == k)
                {
                    _local_3.previewCallbackId = 0;
                    this._Str_3234(_arg_2, true);
                    break;
                }
            }
        }

        public function imageFailed(k:Int)
        {
        }

        function _Str_23368(k:String):String
        {
            var _local_2= this._Str_19039(k);
            if (_local_2.length > 0)
            {
                return k.substring(0, ((k.length - 1) - _local_2.length));
            }
            return k;
        }

        function _Str_19039(k:String):String
        {
            var _local_2= k.indexOf("prizetrophy_2011_");
            if (_local_2 != -1)
            {
                return "";
            }
            var _local_3= (k.lastIndexOf("_") + 1);
            if (_local_3 <= 0)
            {
                return "";
            }
            var _local_4= k.substr(_local_3);
            if (((_local_4.length > 1) || (((!(_local_4 == "g")) && (!(_local_4 == "s"))) && (!(_local_4 == "b")))))
            {
                return "";
            }
            return _local_4;
        }

        function _Str_23372(k:WindowMouseEvent)
        {
            var _local_3:Offer = null;
            this._selectIndex++;
            if ((this._selectIndex : UInt) >= this._trophyOffers.length)
            {
                this._selectIndex = 0;
            }
            var _local_2:Map = this._trophyOffers.getWithIndex(this._selectIndex);
            if (_local_2 != null)
            {
                _local_3 = _local_2.getValue(this._selectType);
                if (_local_3 == null)
                {
                    _local_3 = _local_2.getWithIndex(0);
                }
                if (_local_3 != null)
                {
                    events.dispatchEvent(new SelectProductEvent(_local_3));
                }
            }
        }

        function _Str_25780(k:WindowMouseEvent)
        {
            var _local_3:Offer = null;
            this._selectIndex--;
            if (this._selectIndex < 0)
            {
                this._selectIndex = ASCompat.toInt(this._trophyOffers.length - 1);
            }
            var _local_2:Map = this._trophyOffers.getWithIndex(this._selectIndex);
            if (_local_2 != null)
            {
                _local_3 = _local_2.getValue(this._selectType);
                if (_local_3 == null)
                {
                    _local_3 = _local_2.getWithIndex(0);
                }
                if (_local_3 != null)
                {
                    events.dispatchEvent(new SelectProductEvent(_local_3));
                }
            }
        }

        function _Str_3234(k:BitmapData, _arg_2:Bool)
        {
            var _local_3:Point = null;
            if (((!window.disposed) && (!(this._previewImage == null))))
            {
                if (k == null)
                {
                    k = new BitmapData(1, 1);
                    _arg_2 = true;
                }
                if (this._previewImage.bitmap == null)
                {
                    this._previewImage.bitmap = new BitmapData(this._previewImage.width, this._previewImage.height, true, 0xFFFFFF);
                }
                this._previewImage.bitmap.fillRect(this._previewImage.bitmap.rect, 0xFFFFFF);
                _local_3 = new Point(((this._previewImage.width - k.width) / 2), ((this._previewImage.height - k.height) / 2));
                this._previewImage.bitmap.copyPixels(k, k.rect, _local_3, null, null, true);
                this._previewImage.invalidate();
            }
            if ((_arg_2 && (!(k == null))))
            {
                k.dispose();
            }
        }

        function _Str_6504(k:String)
        {
            var _local_2= Std.downcast(page.viewer.catalog.assets.getAssetByName(k) , BitmapDataAsset);
            if (_local_2 == null)
            {
                this.retrievePreviewAsset(k);
                return;
            }
            this._Str_3234(ASCompat.dynamicAs(_local_2.content , BitmapData), false);
        }

        function retrievePreviewAsset(k:String)
        {
            var _local_2:ASAny = ((page.viewer.catalog.imageGalleryHost + k) + ".gif");
            Logger.log([("[TrophyCatalogWidget] Retrieve Product Preview Asset: " + _local_2)]);
            var _local_3= new URLRequest(_local_2);
            var _local_4= page.viewer.catalog.assets.loadAssetFromFile(k, _local_3, "image/gif");
            _local_4.addEventListener(AssetLoaderEvent.ASSETLOADEREVENTCOMPLETE, this._Str_6676);
        }

        function _Str_6676(k:AssetLoaderEvent)
        {
            var _local_2= ASCompat.dynamicAs(k.target , AssetLoaderStruct);
            if (_local_2 != null)
            {
                this._Str_6504(_local_2.assetName);
            }
        }
    }

