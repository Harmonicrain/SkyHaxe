package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.SelectProductEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events._Str_3308;

     class SingleViewCatalogWidget extends ProductViewCatalogWidget
    {
        public function new(k:IWindowContainer, _arg_2:HabboCatalog)
        {
            super(k, _arg_2);
        }

        override public function dispose()
        {
            super.dispose();
        }

        override public function init():Bool
        {
            if (!super.init())
            {
                return false;
            }
            events.addEventListener(CatalogWidgetEvent.WIDGETS_INITIALIZED, this.onWidgetsInitialized);
            return true;
        }

        public function onWidgetsInitialized(k:_Str_3308)
        {
            if (page.offers.length == 0)
            {
                return;
            }
            var _local_2= page.offers[0];
            events.dispatchEvent(new SelectProductEvent(_local_2));
        }
    }

