package com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.listitem
;
    import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.ExtraInfoListItem;
    import com.sulake.habbo.catalog.HabboCatalog;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.viewer.widgets.BundlePurchaseExtraInfoCatalogWidget;
    import com.sulake.habbo.catalog.viewer.widgets.bundlepurchaseinfodisplay.ExtraInfoItemData;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetBundleDisplayExtraInfoEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class ExtraInfoBundlesInfoItem extends ExtraInfoListItem 
    {
        var _catalog:HabboCatalog;
        var _window:IWindowContainer;
        var _widget:BundlePurchaseExtraInfoCatalogWidget;

        public function new(k:BundlePurchaseExtraInfoCatalogWidget, _arg_2:Int, _arg_3:ExtraInfoItemData, _arg_4:HabboCatalog)
        {
            super(k, _arg_2, _arg_3, ExtraInfoListItem.ALIGN_OVERLAY, true);
            this._catalog = _arg_4;
            this._widget = k;
        }

        override public function getRenderedWindow():IWindowContainer
        {
            if (this._window == null)
            {
                this.createWindow();
            }
            return this._window;
        }

        function createWindow()
        {
            this._window = cast(this._catalog.utils.createWindow("bundlesInfoItem"), IWindowContainer);
            this._window.procedure = this.windowProcedure;
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._widget.events.dispatchEvent(new CatalogWidgetBundleDisplayExtraInfoEvent(CatalogWidgetBundleDisplayExtraInfoEvent.CWPPEIE_ITEM_CLICKED, data, id));
            }
        }
    }

