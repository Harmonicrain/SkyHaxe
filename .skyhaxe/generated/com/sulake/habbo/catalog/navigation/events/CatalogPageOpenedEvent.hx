package com.sulake.habbo.catalog.navigation.events
;
    import flash.events.Event;

     class CatalogPageOpenedEvent extends Event 
    {
        public static inline final CATALOG_PAGE_OPENED= "CATALOG_PAGE_OPENED";

        var _pageId:Int = 0;
        var _pageLocalization:String;

        public function new(k:Int, _arg_2:String, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(CATALOG_PAGE_OPENED, _arg_3, _arg_4);
            this._pageId = k;
            this._pageLocalization = _arg_2;
        }

        public var pageId(get,never):Int;
public function  get_pageId():Int
        {
            return this._pageId;
        }

        public var pageLocalization(get,never):String;
public function  get_pageLocalization():String
        {
            return this._pageLocalization;
        }
    }

