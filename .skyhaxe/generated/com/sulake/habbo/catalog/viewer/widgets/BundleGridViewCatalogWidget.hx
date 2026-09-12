package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.habbo.catalog.viewer._Str_4311;
    import com.sulake.habbo.catalog.viewer.IProductContainer;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetEvent;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.habbo.catalog.viewer.widgets.events.SelectProductEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events._Str_3308;
    import com.sulake.habbo.catalog.viewer.IProduct;
    import com.sulake.core.window.IWindow;
    import flash.display.BitmapData;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import com.sulake.habbo.catalog.viewer.IGridItem;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.room.IStuffData;

     class BundleGridViewCatalogWidget extends CatalogWidget implements _Str_4311 implements  IProductContainer 
    {
        var _offer:IPurchasableOffer;
        var _gridItemLayout:com.sulake.core.utils.xml.XML;
        var _itemGrid:IItemGridWindow;

        public function new(k:IWindowContainer)
        {
            super(k);
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            events.addEventListener(CatalogWidgetEvent.SELECT_PRODUCT, this.onSelectProduct);
            events.addEventListener(CatalogWidgetEvent.WIDGETS_INITIALIZED, this.onWidgetsInitialized);
            var k= Std.downcast(page.viewer.catalog.assets.getAssetByName("gridItem") , XmlAsset);
            this._gridItemLayout = ((k.content : com.sulake.core.utils.xml.XML) );
            this._itemGrid = cast(_window.findChildByName("bundleGrid"), IItemGridWindow);
            return true;
        }

        override public function dispose()
        {
            if (!disposed)
            {
                events.removeEventListener(CatalogWidgetEvent.SELECT_PRODUCT, this.onSelectProduct);
                events.removeEventListener(CatalogWidgetEvent.WIDGETS_INITIALIZED, this.onWidgetsInitialized);
                super.dispose();
            }
        }

        function onWidgetsInitialized(k:_Str_3308)
        {
            var _local_2:IPurchasableOffer = null;
            if (page.offers.length == 1)
            {
                _local_2 = page.offers[0];
                if (_local_2 != null)
                {
                    events.dispatchEvent(new SelectProductEvent(_local_2));
                }
            }
        }

        function onSelectProduct(k:SelectProductEvent)
        {
            this._offer = k.offer;
            this._itemGrid.destroyGridItems();
            this._Str_6159();
        }

        function _Str_6159()
        {
            var _local_2:IProduct = null;
            var _local_3:IWindowContainer = null;
            var _local_4:IWindow = null;
            var _local_5:BitmapData = null;
            var k= Std.downcast(this._offer.page.viewer.catalog.windowManager.buildFromXML(this._gridItemLayout) , IWindowContainer);
            final _iter_ = this._offer.productContainer.products; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.productType == ProductTypeEnum.BADGE)
                {
                }
                else
                {
                    _local_3 = Std.downcast(k.clone() , IWindowContainer);
                    _local_4 = _local_3.findChildByName("clubLevelIcon");
                    if (_local_4 != null)
                    {
                        _local_4.visible = false;
                    }
                    this._itemGrid.addGridItem(_local_3);
                    _local_2.view = _local_3;
                    _local_5 = _local_2.initIcon(this);
                    if (_local_5 != null)
                    {
                        _local_5.dispose();
                    }
                    _local_2.grid = this;
                }
            }
        }

        public var offer(get,never):IPurchasableOffer;
public function  get_offer():IPurchasableOffer
        {
            return this._offer;
        }

        public function select(k:IGridItem, _arg_2:Bool)
        {
        }

        public function _Str_9974(k:IGridItem):Bool
        {
            return false;
        }

        public function initProductIcon(k:IRoomEngine, _arg_2:IStuffData=null)
        {
        }

        public function activate()
        {
        }

        public var products(get,never):Vector<IProduct>;
public function  get_products():Vector<IProduct>
        {
            return null;
        }

        public var _Str_6851(get,never):IProduct;
public function  get__Str_6851():IProduct
        {
            return null;
        }

        
        public var view(get,set):IWindowContainer;
public function  set_view(k:IWindowContainer):IWindowContainer        {
return k;
        }
public function  get_view():IWindowContainer
        {
            return null;
        }

        public var grid(never,set):_Str_4311;
public function  set_grid(k:_Str_4311):_Str_4311        {
return k;
        }

        public function _Str_15497(k:Int)
        {
        }
    }

