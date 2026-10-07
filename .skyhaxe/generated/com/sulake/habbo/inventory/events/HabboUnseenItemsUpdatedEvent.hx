package com.sulake.habbo.inventory.events
;
    import flash.events.Event;

     class HabboUnseenItemsUpdatedEvent extends Event 
    {
        public static inline final HUIUE_UNSEEN_ITEMS_CHANGED= "HUIUE_UNSEEN_ITEMS_CHANGED";

        var _inventoryCount:Int = 0;
        var _categoryCount:ASDictionary<ASAny,ASAny>;

        public function new(k:Bool=false, _arg_2:Bool=false)
        {
            super(HUIUE_UNSEEN_ITEMS_CHANGED);
            this._categoryCount = new ASDictionary<ASAny,ASAny>();
        }

        public function _Str_23396(k:Int, _arg_2:Int)
        {
            this._categoryCount[Std.string(k)] = _arg_2;
        }

        public function _Str_25582(k:Int):Int
        {
            return ASCompat.toInt(this._categoryCount[Std.string(k)]);
        }

        
        public var _Str_13996(get,set):Int;
public function  set__Str_13996(k:Int):Int        {
            return this._inventoryCount = k;
        }
public function  get__Str_13996():Int
        {
            return this._inventoryCount;
        }
    }

