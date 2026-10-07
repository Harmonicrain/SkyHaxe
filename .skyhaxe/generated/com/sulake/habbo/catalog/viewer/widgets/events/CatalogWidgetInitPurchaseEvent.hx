package com.sulake.habbo.catalog.viewer.widgets.events
;
    import flash.events.Event;

     class CatalogWidgetInitPurchaseEvent extends Event 
    {
        var _enableBuyAsGift:Bool = true;
        var _userName:String;

        public function new(k:Bool=true, _arg_2:String=null, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(CatalogWidgetEvent.INIT_PURCHASE, _arg_3, _arg_4);
            this._enableBuyAsGift = k;
            this._userName = _arg_2;
        }

        public var _Str_25955(get,never):Bool;
public function  get__Str_25955():Bool
        {
            return this._enableBuyAsGift;
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return this._userName;
        }
    }

