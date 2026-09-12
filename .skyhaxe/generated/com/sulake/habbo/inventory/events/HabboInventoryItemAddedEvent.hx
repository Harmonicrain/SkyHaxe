package com.sulake.habbo.inventory.events
;
    import flash.events.Event;

     class HabboInventoryItemAddedEvent extends Event 
    {
        public static inline final HABBO_INVENTORY_ITEM_ADDED= "HABBO_INVENTORY_ITEM_ADDED";

        var _classId:Int = 0;
        var _stripId:Int = 0;
        var _category:Int = 0;

        public function new(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Bool=false, _arg_5:Bool=false)
        {
            super(HABBO_INVENTORY_ITEM_ADDED, _arg_4, _arg_5);
            this._classId = k;
            this._stripId = _arg_2;
            this._category = _arg_3;
        }

        public var classId(get,never):Int;
public function  get_classId():Int
        {
            return this._classId;
        }

        public var stripId(get,never):Int;
public function  get_stripId():Int
        {
            return this._stripId;
        }

        public var category(get,never):Int;
public function  get_category():Int
        {
            return this._category;
        }
    }

