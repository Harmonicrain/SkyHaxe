package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.SelectProductEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events._Str_3308;

     class FirstProductSelectorCatalogWidget extends CatalogWidget
    {
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
            events.addEventListener(CatalogWidgetEvent.WIDGETS_INITIALIZED, this.onWidgetsInitialized);
            return true;
        }

        function onWidgetsInitialized(k:_Str_3308)
        {
            if (page.offers.length == 0)
            {
                return;
            }
            var _local_2= page.offers[0];
            events.dispatchEvent(new SelectProductEvent(_local_2));
        }
    }

