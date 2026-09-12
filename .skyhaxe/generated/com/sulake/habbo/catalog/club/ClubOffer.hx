package com.sulake.habbo.catalog.club
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.localization.ILocalization;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.IWindow;

     class ClubOffer implements IDisposable 
    {
        var _offer:ClubBuyOfferData;
        var _window:IWindowContainer;
        var _habboCatalog:HabboCatalog;
        var _disposed:Bool = false;
        var _Str_25725:String;

        public function new(k:ClubBuyOfferData, _arg_2:HabboCatalog, _arg_3:String)
        {
            var _local_5:ILocalization = null;
            this._offer = k;
            this._habboCatalog = _arg_2;
            this._Str_25725 = _arg_3;
            this._window = Std.downcast(this._habboCatalog.utils.createWindow("vip_buy_item") , IWindowContainer);
            var _local_4= this._habboCatalog.localization;
            if (k.months > 0)
            {
                _local_4.registerParameter("catalog.vip.item.header.months", "num_months", Std.string(k.months));
                _local_5 = _local_4.getLocalizationRaw("catalog.vip.item.header.months");
            }
            else
            {
                _local_4.registerParameter("catalog.vip.item.header.days", "num_days", Std.string(k._Str_15178));
                _local_5 = _local_4.getLocalizationRaw("catalog.vip.item.header.days");
            }
            this._window.findChildByName("item_header").caption = ((_local_5 != null) ? _local_5.value : "-");
            this._habboCatalog.utils._Str_6455(Std.downcast(this._window.findChildByName("item_price") , IWindowContainer), this._offer);
            this._window.findChildByName("item_buy").addEventListener(WindowMouseEvent.CLICK, this.onBuy);
            if (k.giftable)
            {
                this._window.findChildByName("item_gift").addEventListener(WindowMouseEvent.CLICK, this._Str_18825);
            }
            else
            {
                this._window.findChildByName("item_gift").visible = false;
            }
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._window.dispose();
                this._window = null;
                this._disposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        function onBuy(k:WindowMouseEvent)
        {
            this._habboCatalog.purchaseWillBeGift(false);
            this._habboCatalog.showPurchaseConfirmation(this._offer, ((this._offer.page == null) ? -1 : this._offer.page.pageId));
        }

        function _Str_18825(k:WindowMouseEvent)
        {
            this._habboCatalog.purchaseWillBeGift(true);
            this._habboCatalog.showPurchaseConfirmation(this._offer, ((this._offer.page == null) ? -1 : this._offer.page.pageId));
        }

        public var window(get,never):IWindow;
public function  get_window():IWindow
        {
            return this._window;
        }
    }

