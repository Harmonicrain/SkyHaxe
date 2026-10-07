package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IButtonWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class BuilderAddonsCatalogWidget extends CatalogWidget implements IDisposable 
    {
        var _catalog:HabboCatalog;

        public function new(k:IWindowContainer, _arg_2:HabboCatalog)
        {
            super(k);
            this._catalog = _arg_2;
        }

        override public function init():Bool
        {
            var _local_5:IPurchasableOffer = null;
            var _local_6:IWindowContainer = null;
            if (!super.init())
            {
                return false;
            }
            _window.procedure = this.windowProcedure;
            var k= Std.downcast(_window.findChildByName("addons_list") , IItemListWindow);
            var _local_2= k.removeListItemAt(0);
            var _local_3 = 0;
            var _local_4:ASAny = (this._catalog.builderSecondsLeft > 0);
            _window.findChildByName("trial_warning").visible = (!_local_4);
            final _iter_ = page.offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                _local_6 = Std.downcast(_local_2.clone() , IWindowContainer);
                _local_6.findChildByName("item_header").caption = _local_5.localizationName;
                _local_6.findChildByName("item_price").caption = Std.string(_local_5.priceInCredits);
                _local_6.findChildByName("item_buy").caption = _local_5.localizationDescription;
                _local_6.findChildByName("item_buy").id = _local_3;
                if (_local_5.priceInActivityPoints > 0)
                {
                    _local_6.findChildByName("diamonds_icon").visible = true;
                    _local_6.findChildByName("diamonds_price").visible = true;
                    _local_6.findChildByName("diamonds_price").caption = Std.string(_local_5.priceInActivityPoints);
                }
                if (!_local_4)
                {
                    cast(_local_6.findChildByName("item_buy"), IButtonWindow).disable();
                }
                _local_3++;
                k.addListItem(_local_6);
            }
            return true;
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            if (_arg_2.name == "item_buy")
            {
                this._catalog.showPurchaseConfirmation(page.offers[_arg_2.id], page.pageId);
            }
        }
    }

