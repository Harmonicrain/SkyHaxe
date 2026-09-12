package com.sulake.habbo.room.utils
;
     class RoomObjectFurniIconAssetListener
    {
        var _roomId:Int = 0;
        var _objectId:Int = 0;
        var _category:Int = 0;

        public function new(roomId:Int, objectId:Int, category:Int)
        {
            this._roomId = roomId;
            this._objectId = objectId;
            this._category = category;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

        public var objectId(get,never):Int;
public function  get_objectId():Int
        {
            return this._objectId;
        }

        public var category(get,never):Int;
public function  get_category():Int
        {
            return this._category;
        }
    }

