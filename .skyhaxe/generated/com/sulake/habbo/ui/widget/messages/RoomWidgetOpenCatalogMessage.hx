package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetOpenCatalogMessage extends RoomWidgetMessage 
    {
        public static inline final RWGOI_MESSAGE_OPEN_CATALOG= "RWGOI_MESSAGE_OPEN_CATALOG";
        public static inline final RWOCM_CLUB_MAIN= "RWOCM_CLUB_MAIN";
        public static inline final RWOCM_PIXELS= "RWOCM_PIXELS";
        public static inline final RWOCM_CREDITS= "RWOCM_CREDITS";
        public static inline final RWOCM_SHELLS= "RWOCM_SHELLS";

        var _pageKey:String = "";

        public function new(k:String)
        {
            super(RWGOI_MESSAGE_OPEN_CATALOG);
            this._pageKey = k;
        }

        public var _Str_23670(get,never):String;
public function  get__Str_23670():String
        {
            return this._pageKey;
        }
    }

