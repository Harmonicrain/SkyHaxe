package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetOpenInventoryMessage extends RoomWidgetMessage 
    {
        public static inline final RWGOI_MESSAGE_OPEN_INVENTORY= "RWGOI_MESSAGE_OPEN_INVENTORY";
        public static inline final INVENTORY_EFFECTS= "inventory_effects";
        public static inline final INVENTORY_BADGES= "inventory_badges";
        public static inline final INVENTORY_CLOTHES= "inventory_clothes";
        public static inline final INVENTORY_FURNITURE= "inventory_furniture";

        var _inventoryType:String;

        public function new(k:String)
        {
            super(RWGOI_MESSAGE_OPEN_INVENTORY);
            this._inventoryType = k;
        }

        public var _Str_16732(get,never):String;
public function  get__Str_16732():String
        {
            return this._inventoryType;
        }
    }

