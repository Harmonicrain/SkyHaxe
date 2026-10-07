package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.SelectProductEvent;

     class SimplePriceCatalogWidget extends CatalogWidget
    {
        var _catalog:HabboCatalog;
        var _priceWidget:IWindow;

        public function new(k:IWindowContainer, _arg_2:HabboCatalog)
        {
            super(k);
            this._catalog = _arg_2;
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            events.addEventListener(CatalogWidgetEvent.SELECT_PRODUCT, this.onSelectProduct);
            return true;
        }

        function onSelectProduct(k:SelectProductEvent)
        {
            this._priceWidget = this._catalog.utils._Str_7075(k.offer, _window , this._priceWidget, _window.findChildByName("fake_productimage"), 0, true, 0);
        }
    }

