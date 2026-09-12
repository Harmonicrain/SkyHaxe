package com.sulake.habbo.room.messages
;
    import com.sulake.room.messages.RoomObjectUpdateMessage;

     class RoomObjectItemDataUpdateMessage extends RoomObjectUpdateMessage 
    {
        var _itemData:String;

        public function new(k:String)
        {
            super(null, null);
            this._itemData = k;
        }

        public var itemData(get,never):String;
public function  get_itemData():String
        {
            return this._itemData;
        }
    }

