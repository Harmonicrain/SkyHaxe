package com.sulake.habbo.inventory.events
;
    import flash.events.Event;

     class HabboInventoryFurniListParsedEvent extends Event 
    {
        public static inline final HFLPE_FURNI_LIST_PARSED= "HFLPE_FURNI_LIST_PARSED";

        var _category:String;

        public function new(k:String, _arg_2:Bool=false, _arg_3:Bool=false)
        {
            super(HFLPE_FURNI_LIST_PARSED);
            this._category = k;
        }

        public var category(get,never):String;
public function  get_category():String
        {
            return this._category;
        }
    }

