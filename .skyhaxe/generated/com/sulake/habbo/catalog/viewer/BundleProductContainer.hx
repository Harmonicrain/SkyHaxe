package com.sulake.habbo.catalog.viewer
;
    import flash.display.BitmapData;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.catalog._enum.ProductTypeEnum;
    import com.sulake.core.window.components.IItemGridWindow;
    import com.sulake.core.window.components.ITextWindow;

     class BundleProductContainer extends ProductContainer implements _Str_4311 
    {
        var _bundleIcon:BitmapData;

        public function new(k:IPurchasableOffer, _arg_2:Vector<IProduct>, _arg_3:HabboCatalog)
        {
            super(k, _arg_2, _arg_3);
            var _local_4= Std.downcast(_arg_3.assets.getAssetByName("ctlg_pic_deal_icon_narrow") , BitmapDataAsset);
            if (_local_4 != null)
            {
                this._bundleIcon = ASCompat.dynamicAs(_local_4.content , BitmapData);
            }
            else
            {
                this._bundleIcon = new BitmapData(1, 1, true, 0xFFFFFF);
            }
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            this._bundleIcon = null;
            super.dispose();
        }

        override public function initProductIcon(k:IRoomEngine, _arg_2:IStuffData=null)
        {
            setIconImage(this._bundleIcon.clone(), true);
        }

        public function _Str_6159(k:IItemGridWindow, _arg_2:com.sulake.core.utils.xml.XML)
        {
            var _local_4:IProduct = null;
            var _local_5:IWindowContainer = null;
            var _local_6:IWindow = null;
            var _local_7:BitmapData = null;
            var _local_3= Std.downcast(catalog.windowManager.buildFromXML(_arg_2) , IWindowContainer);
            final _iter_ = offer.productContainer.products; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                if (_local_4.productType == ProductTypeEnum.BADGE)
                {
                }
                else
                {
                    _local_5 = Std.downcast(_local_3.clone() , IWindowContainer);
                    _local_6 = _local_5.findChildByName("clubLevelIcon");
                    if (_local_6 != null)
                    {
                        _local_6.visible = false;
                    }
                    k.addGridItem(_local_5);
                    _local_4.view = _local_5;
                    _local_7 = _local_4.initIcon(this);
                    if (_local_7 != null)
                    {
                        _local_7.dispose();
                    }
                    _local_4.grid = this;
                }
            }
        }

        public function _Str_21877(k:Int)
        {
            var _local_2:IWindow = Std.downcast(_view.findChildByName("bundleCounter") , ITextWindow);
            if (_local_2 != null)
            {
                _local_2.caption = Std.string(k);
            }
        }

        public function select(k:IGridItem, _arg_2:Bool)
        {
            Logger.log([("Product Bundle, select item: " + k)]);
        }

        public function _Str_9974(k:IGridItem):Bool
        {
            return false;
        }

        override public function  set_view(k:IWindowContainer):IWindowContainer        {
            super.view = k;
            this._Str_21877(999);
return k;
        }
    }

