package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetRoomObjectMessage extends RoomWidgetMessage 
    {
        public static inline final RWROM_GET_OBJECT_INFO= "RWROM_GET_OBJECT_INFO";
        public static inline final RWROM_GET_OBJECT_NAME= "RWROM_GET_OBJECT_NAME";
        public static inline final RWROM_SELECT_OBJECT= "RWROM_SELECT_OBJECT";
        public static inline final RWROM_GET_OWN_CHARACTER_INFO= "RWROM_GET_OWN_CHARACTER_INFO";
        public static inline final RWROM_GET_AVATAR_LIST= "RWROM_GET_AVATAR_LIST";

        var _id:Int = 0;
        var _category:Int = 0;

        public function new(k:String, id:Int, category:Int)
        {
            super(k);
            this._id = id;
            this._category = category;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var category(get,never):Int;
public function  get_category():Int
        {
            return this._category;
        }
    }

