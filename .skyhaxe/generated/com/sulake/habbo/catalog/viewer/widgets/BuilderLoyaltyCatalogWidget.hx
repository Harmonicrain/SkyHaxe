package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.IPurchasableOffer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;

     class BuilderLoyaltyCatalogWidget extends CatalogWidget implements IDisposable 
    {
        var _catalog:HabboCatalog;

        public function new(k:IWindowContainer, _arg_2:HabboCatalog)
        {
            super(k);
            this._catalog = _arg_2;
        }

        override public function init():Bool
        {
            var _local_4:IPurchasableOffer = null;
            var _local_5:IWindowContainer = null;
            if (!super.init())
            {
                return false;
            }
            _window.procedure = this.windowProcedure;
            var k= Std.downcast(_window.findChildByName("loyalty_list") , IItemListWindow);
            var _local_2= k.removeListItemAt(0);
            var _local_3 = 0;
            final _iter_ = page.offers; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_4  = _tmp_;
                _local_5 = Std.downcast(_local_2.clone() , IWindowContainer);
                _local_5.findChildByName("item_header").caption = _local_4.localizationName;
                this._catalog.utils._Str_6455(Std.downcast(_local_5.findChildByName("item_cost_box") , IWindowContainer), _local_4);
                _local_5.findChildByName("item_buy").caption = _local_4.localizationDescription;
                _local_5.findChildByName("item_buy").id = _local_3;
                _local_3++;
                k.addListItem(_local_5);
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

