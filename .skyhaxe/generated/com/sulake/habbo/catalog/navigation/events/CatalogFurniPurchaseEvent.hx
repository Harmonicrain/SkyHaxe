package com.sulake.habbo.catalog.navigation.events
;
    import flash.events.Event;

     class CatalogFurniPurchaseEvent extends Event 
    {
        public static inline final CATALOG_FURNI_PURCHASE= "CATALOG_FURNI_PURCHASE";

        var _localizationId:String;

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(CATALOG_FURNI_PURCHASE, _arg_2, _arg_3);
            this._localizationId = k;
        }

        public var localizationId(get,never):String;
public function  get_localizationId():String
        {
            return this._localizationId;
        }
    }

