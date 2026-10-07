package com.sulake.habbo.ui.widget.events
;
     class _Str_2693 extends RoomWidgetUpdateEvent 
    {
        public static inline final RWPLEE_SHOW_PLAYLIST_EDITOR= "RWPLEE_SHOW_PLAYLIST_EDITOR";
        public static inline final RWPLEE_HIDE_PLAYLIST_EDITOR= "RWPLEE_HIDE_PLAYLIST_EDITOR";
        public static inline final RWPLEE_INVENTORY_UPDATED= "RWPLEE_INVENTORY_UPDATED";
        public static inline final RWPLEE_SONG_DISK_INVENTORY_UPDATED= "RWPLEE_SONG_DISK_INVENTORY_UPDATED";
        public static inline final RWPLEE_PLAY_LIST_UPDATED= "RWPLEE_PLAY_LIST_UPDATED";
        public static inline final RWPLEE_PLAY_LIST_FULL= "RWPLEE_PLAY_LIST_FULL";

        var _furniId:Int = 0;

        public function new(k:String, _arg_2:Int=-1, _arg_3:Bool=false, _arg_4:Bool=false)
        {
            super(k, _arg_3, _arg_4);
            this._furniId = _arg_2;
        }

        public var furniId(get,never):Int;
public function  get_furniId():Int
        {
            return this._furniId;
        }
    }

