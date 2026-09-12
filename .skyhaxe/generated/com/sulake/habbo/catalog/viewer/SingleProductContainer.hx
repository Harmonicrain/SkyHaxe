package com.sulake.habbo.catalog.viewer
;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.ILimitedItemGridOverlayWidget;
    import com.sulake.core.assets.AssetLoaderStruct;
    import com.sulake.core.assets.loaders.AssetLoaderEvent;
    import com.sulake.core.window.IWindowContainer;

     class SingleProductContainer extends ProductContainer 
    {
        public function new(k:IPurchasableOffer, _arg_2:Vector<IProduct>, _arg_3:HabboCatalog)
        {
            super(k, _arg_2, _arg_3);
        }

        override public function initProductIcon(k:IRoomEngine, _arg_2:IStuffData=null)
        {
            var _local_3= _Str_6851;
            var _local_4= _local_3.initIcon(this, this, this, offer , _icon, _arg_2, this._Str_6676);
            this.setIconImage(_local_4, true);
        }

        public function _Str_23923()
        {
            _view.findChildByName("unique_item_background_bitmap").visible = true;
            var k= cast(_view.findChildByName("unique_item_overlay_container"), IWidgetWindow);
            var _local_2= cast(k.widget, ILimitedItemGridOverlayWidget);
            k.visible = true;
            _local_2.serialNumber = _Str_6851.uniqueLimitedItemSeriesSize;
            _local_2.animated = true;
            if (_Str_6851.uniqueLimitedItemsLeft == 0)
            {
                _view.findChildByName("unique_item_sold_out_bitmap").visible = true;
            }
            else
            {
                _view.findChildByName("unique_item_sold_out_bitmap").visible = false;
            }
        }

        function _Str_6676(k:AssetLoaderEvent)
        {
            var _local_2:AssetLoaderStruct = null;
            if (((!disposed) && (!(offer.page.viewer.catalog == null))))
            {
                _local_2 = ASCompat.dynamicAs(k.target , AssetLoaderStruct);
                if (_local_2 != null)
                {
                    catalog.setImageFromAsset(_icon, _local_2.assetName, null);
                }
            }
        }

        override public function  set_view(k:IWindowContainer):IWindowContainer        {
            super.view = k;
            if (offer.product.isUniqueLimitedItem)
            {
                Std.downcast(offer.productContainer , SingleProductContainer)._Str_23923();
            }
return k;
        }
    }

