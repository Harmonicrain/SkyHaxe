package com.sulake.habbo.catalog.purse
;
    import flash.events.Event;

     class PurseUpdateEvent extends Event 
    {
        public static inline final CATALOG_PURSE_UPDATE= "catalog_purse_update";

        public function new(k:Bool=false, _arg_2:Bool=false)
        {
            super(CATALOG_PURSE_UPDATE, k, _arg_2);
        }
    }

