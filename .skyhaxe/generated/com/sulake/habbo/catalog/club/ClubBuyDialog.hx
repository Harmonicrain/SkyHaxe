package com.sulake.habbo.catalog.club
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.viewer.ICatalogPage;
    import com.sulake.core.localization.ILocalization;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.IWindow;

     class ClubBuyDialog 
    {
        var _offer:ClubBuyOfferData;
        var _window:IWindowContainer;
        var _Str_2619:ICatalogPage;

        public function new(k:ClubBuyOfferData, _arg_2:ICatalogPage)
        {
            var _local_3:com.sulake.core.utils.xml.XML = null;
            var _local_5:ILocalization = null;
            this._offer = k;
            this._Str_2619 = _arg_2;
            if (k.vip)
            {
                _local_3 = this.getAssetXML("club_buy_vip_item");
            }
            else
            {
                _local_3 = this.getAssetXML("club_buy_hc_item");
            }
            this._window = Std.downcast(this._Str_2619.viewer.catalog.windowManager.buildFromXML(_local_3) , IWindowContainer);
            var _local_4= Std.downcast(_arg_2.viewer.catalog , HabboCatalog).localization;
            _local_4.registerParameter("catalog.club.item.header", "months", Std.string(k.months));
            _local_5 = _local_4.getLocalizationRaw("catalog.club.item.header");
            this._window.findChildByName("item_header").caption = _local_5.value;
            _local_4.registerParameter("catalog.club.price", "price", Std.string(k.priceCredits));
            _local_5 = _local_4.getLocalizationRaw("catalog.club.price");
            this._window.findChildByName("item_price").caption = _local_5.value;
            var _local_6= Std.downcast(this._window.findChildByName("item_buy") , IButtonWindow);
            if (_local_6 != null)
            {
                _local_6.addEventListener(WindowMouseEvent.CLICK, this.onBuy);
            }
        }

        public function dispose()
        {
            this._window.dispose();
        }

        function onBuy(k:WindowMouseEvent)
        {
            cast(this._Str_2619.viewer.catalog, HabboCatalog).showPurchaseConfirmation(this._offer, this._Str_2619.pageId);
        }

        function getAssetXML(k:String):com.sulake.core.utils.xml.XML
        {
            if (((((!(this._Str_2619 != null)) || (!(this._Str_2619.viewer != null))) || (!(this._Str_2619.viewer.catalog != null))) || (!(this._Str_2619.viewer.catalog.assets != null))))
            {
                return null;
            }
            var _local_2= Std.downcast(this._Str_2619.viewer.catalog.assets.getAssetByName(k) , XmlAsset);
            if (_local_2 == null)
            {
                return null;
            }
            return (_local_2.content : com.sulake.core.utils.xml.XML) ;
        }

        public var window(get,never):IWindow;
public function  get_window():IWindow
        {
            return this._window;
        }
    }

