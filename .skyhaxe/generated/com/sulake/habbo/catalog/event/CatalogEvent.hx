package com.sulake.habbo.catalog.event
;
    import flash.events.Event;

     class CatalogEvent extends Event 
    {
        public static inline final CATALOG_INITIALIZED= "CATALOG_INITIALIZED";
        public static inline final CATALOG_NOT_READY= "CATALOG_NOT_READY";
        public static inline final CATALOG_NEW_ITEMS_SHOW= "CATALOG_NEW_ITEMS_SHOW";
        public static inline final CATALOG_NEW_ITEMS_HIDE= "CATALOG_NEW_ITEMS_HIDE";
        public static inline final CATALOG_USER_SELECTED= "CATALOG_USER_SELECTED";
        public static inline final CATALOG_BUILDER_MEMBERSHIP_EXPIRED= "CATALOG_BUILDER_MEMBERSHIP_EXPIRED";
        public static inline final CATALOG_BUILDER_MEMBERSHIP_IN_GRACE= "CATALOG_BUILDER_MEMBERSHIP_IN_GRACE";
        public static inline final CATALOG_INVISIBLE_PAGE_VISITED= "CATALOG_INVISIBLE_PAGE_VISITED";

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(k, _arg_2, _arg_3);
        }
    }

