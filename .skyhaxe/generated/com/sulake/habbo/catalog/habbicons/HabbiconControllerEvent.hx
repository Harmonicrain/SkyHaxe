package com.sulake.habbo.catalog.habbicons
;
    import flash.events.Event;

     class HabbiconControllerEvent extends Event
    {
        public static inline final OWNED_HABBICONS_UPDATED= "hce_owned_habbicons_updated";
        public static inline final SHOP_DATA_UPDATED= "hce_shop_data_updated";
        public static inline final STATUS_CHANGED= "hce_habbicon_status_changed";
        public static inline final RECENT_HABBICONS_UPDATED= "hce_recent_habbicons_updated";
        public static inline final ROOM_USE_HABBICON= "hce_room_use_habbicon";

        var _habbiconId:Int = 0;
        var _collectionId:Int = 0;
        var _roomIndex:Int = 0;

        public function new(type:String, habbiconId:Int = 0, collectionId:Int = 0, roomIndex:Int = 0)
        {
            super(type, false, false);
            this._habbiconId = habbiconId;
            this._collectionId = collectionId;
            this._roomIndex = roomIndex;
        }

        public var habbiconId(get,never):Int;
public function  get_habbiconId():Int
        {
            return this._habbiconId;
        }

        public var collectionId(get,never):Int;
public function  get_collectionId():Int
        {
            return this._collectionId;
        }

        public var roomIndex(get,never):Int;
public function  get_roomIndex():Int
        {
            return this._roomIndex;
        }

        override public function clone():Event
        {
            return new HabbiconControllerEvent(type, this._habbiconId, this._collectionId, this._roomIndex);
        }
    }

