package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.SelectProductEvent;

     class SpecialInfoCatalogWidget extends CatalogWidget
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
            _Str_2819(CatalogWidgetEnum.SPECIAL_INFO);
            _window.findChildByName("ctlg_special_txt").caption = "";
            events.addEventListener(CatalogWidgetEvent.SELECT_PRODUCT, this._Str_4806);
            return true;
        }

        function _Str_4806(k:SelectProductEvent)
        {
            if (k == null)
            {
                return;
            }
            _window.visible = false;
        }
    }

