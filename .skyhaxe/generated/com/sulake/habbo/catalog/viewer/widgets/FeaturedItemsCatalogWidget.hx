package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.communication.messages.incoming.catalog.FrontPageItem;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.catalog._enum.CatalogPageName;
    import com.sulake.habbo.catalog._enum.CatalogType;
    import com.sulake.core.window.events.WindowEvent;

     class FeaturedItemsCatalogWidget extends CatalogWidget
    {
        var _catalog:HabboCatalog;
        var _itemListWindow:IItemListWindow;
        var _template:IWindowContainer;

        public function new(k:IWindowContainer, _arg_2:HabboCatalog)
        {
            super(k);
            this._catalog = _arg_2;
        }

        override public function dispose()
        {
            if (!disposed)
            {
                this._catalog = null;
                this._itemListWindow.dispose();
                this._itemListWindow = null;
                this._template.dispose();
                this._template = null;
                super.dispose();
            }
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            this._itemListWindow = Std.downcast(window.findChildByName("itemlist_featured") , IItemListWindow);
            this._template = Std.downcast(this._itemListWindow.getListItemByName("featured_item_template") , IWindowContainer);
            this._itemListWindow.removeListItems();
            if (((this._catalog.frontPageItems == null) || (this._catalog.frontPageItems.length == 0)))
            {
                return true;
            }
            var k= Std.downcast(_window.findChildByName("firstitem") , IWindowContainer);
            this._Str_15147(this._catalog.frontPageItems[0], k);
            var _local_2= 1;
            while (_local_2 < Math.min(4, this._catalog.frontPageItems.length))
            {
                this._itemListWindow.addListItem(this._Str_23881(this._catalog.frontPageItems[_local_2]));
                _local_2++;
            }
            return true;
        }

        function _Str_23881(k:FrontPageItem):IWindowContainer
        {
            return this._Str_15147(k, Std.downcast(this._template.clone() , IWindowContainer));
        }

        function _Str_15147(k:FrontPageItem, _arg_2:IWindowContainer):IWindowContainer
        {
            var _local_5:String = null;
            var _local_6:IStaticBitmapWrapperWindow = null;
            var _local_3= Std.downcast(_arg_2.findChildByName("item_title") , ITextWindow);
            _local_3.text = k.itemName;
            if (((!(k.itemPromoImage == null)) && (!(k.itemPromoImage == ""))))
            {
                _local_5 = this._catalog.context.configuration.getProperty("image.library.url");
                _local_6 = Std.downcast(_arg_2.findChildByName("item_image") , IStaticBitmapWrapperWindow);
                _local_6.assetUri = (_local_5 + k.itemPromoImage);
            }
            var _local_4= _arg_2.getChildByName("event_catcher_region");
            if (_local_4 != null)
            {
                _local_4.procedure = this._Str_5162;
            }
            return _arg_2;
        }

        function _Str_5162(k:WindowEvent, _arg_2:IWindow)
        {
            var _local_3 = 0;
            var _local_4:FrontPageItem = null;
            if (k.type == WindowMouseEvent.DOWN)
            {
                _local_3 = this._itemListWindow.getListItemIndex(_arg_2.parent);
                _local_3 = ((_local_3 < 0) ? 0 : (_local_3 + 1));
                _local_4 = this._catalog.frontPageItems[_local_3];
                switch (_local_4.type)
                {
                    case FrontPageItem.ITEM_CATALOGUE_PAGE:
                        if (_local_4.cataloguePageLocation == CatalogPageName.ROOM_BUNDLES_MOBILE)
                        {
                            return this._catalog.openCatalogPage(CatalogPageName.ROOM_BUNDLES, CatalogType.NORMAL);
                        }
                        if (_local_4.cataloguePageLocation == CatalogPageName.MOBILE_SUBSCRIPTIONS)
                        {
                            return this._catalog.openCatalogPage(CatalogPageName.HC_MEMBERSHIP, CatalogType.NORMAL);
                        }
                        this._catalog.openCatalogPage(_local_4.cataloguePageLocation, CatalogType.NORMAL);
                        return;
                    case FrontPageItem.ITEM_PRODUCT_OFFER:
                        this._catalog.openCatalogPageByOfferId(_local_4.productOfferID, CatalogType.NORMAL);
                        return;
                }
            }
        }
    }

