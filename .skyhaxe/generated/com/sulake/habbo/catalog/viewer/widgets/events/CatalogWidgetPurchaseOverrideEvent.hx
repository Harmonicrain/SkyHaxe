package com.sulake.habbo.catalog.viewer.widgets.events
;
    import flash.events.Event;

     class CatalogWidgetPurchaseOverrideEvent extends Event 
    {
        var _callback:ASFunction;

        public function new(k:ASFunction, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(CatalogWidgetEvent.PURCHASE_OVERRIDE, _arg_2, _arg_3);
            this._callback = k;
        }

        public var callback(get,never):ASFunction;
public function  get_callback():ASFunction
        {
            return this._callback;
        }
    }

