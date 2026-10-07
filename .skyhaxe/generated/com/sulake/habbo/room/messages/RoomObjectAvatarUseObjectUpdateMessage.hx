package com.sulake.habbo.room.messages
;
     class RoomObjectAvatarUseObjectUpdateMessage extends RoomObjectUpdateStateMessage 
    {
        var _itemType:Int = 0;

        public function new(k:Int)
        {
            super();
            this._itemType = k;
        }

        public var itemType(get,never):Int;
public function  get_itemType():Int
        {
            return this._itemType;
        }
    }

