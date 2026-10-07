package com.sulake.habbo.catalog.viewer.widgets
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetEvent;
    import com.sulake.habbo.catalog.viewer.widgets.events.CatalogWidgetShowWarningTextEvent;

     class WarningCatalogWidget extends CatalogWidget
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
            _window.findChildByName("warning_text").caption = "";
            events.addEventListener(CatalogWidgetEvent.SHOW_WARNING_TEXT, this._Str_22701);
            return true;
        }

        function _Str_22701(k:CatalogWidgetShowWarningTextEvent)
        {
            _window.findChildByName("warning_text").caption = k.text;
        }
    }

