package com.sulake.habbo.room.messages
;
     class RoomObjectAvatarCarryObjectUpdateMessage extends RoomObjectUpdateStateMessage 
    {
        var _itemType:Int = 0;
        var _itemName:String;

        public function new(k:Int, _arg_2:String)
        {
            super();
            this._itemType = k;
            this._itemName = _arg_2;
        }

        public var itemType(get,never):Int;
public function  get_itemType():Int
        {
            return this._itemType;
        }

        public var itemName(get,never):String;
public function  get_itemName():String
        {
            return this._itemName;
        }
    }

