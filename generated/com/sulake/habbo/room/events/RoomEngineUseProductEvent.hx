package com.sulake.habbo.room.events
;
     class RoomEngineUseProductEvent extends RoomEngineObjectEvent 
    {
        public static inline final ROSM_USE_PRODUCT_FROM_ROOM= "ROSM_USE_PRODUCT_FROM_ROOM";
        public static inline final ROSM_USE_PRODUCT_FROM_INVENTORY= "ROSM_USE_PRODUCT_FROM_INVENTORY";

        var _inventoryStripId:Int = 0;
        var _furnitureTypeId:Int = 0;

        public function new(k:String, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int=-1, _arg_6:Int=-1, _arg_7:Bool=false, _arg_8:Bool=false)
        {
            super(k, _arg_2, _arg_3, _arg_4, _arg_7, _arg_8);
            this._inventoryStripId = _arg_5;
            this._furnitureTypeId = _arg_6;
        }

        public var inventoryStripId(get,never):Int;
function  get_inventoryStripId():Int
        {
            return this._inventoryStripId;
        }

        public var furnitureTypeId(get,never):Int;
function  get_furnitureTypeId():Int
        {
            return this._furnitureTypeId;
        }
    }

