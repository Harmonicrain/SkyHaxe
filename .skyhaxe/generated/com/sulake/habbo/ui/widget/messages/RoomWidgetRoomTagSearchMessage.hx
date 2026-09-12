package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetRoomTagSearchMessage extends RoomWidgetMessage 
    {
        public static inline final RWRTSM_ROOM_TAG_SEARCH= "RWRTSM_ROOM_TAG_SEARCH";

        var _tag:String = "";

        public function new(k:String)
        {
            super(RWRTSM_ROOM_TAG_SEARCH);
            this._tag = k;
        }

        public var tag(get,never):String;
public function  get_tag():String
        {
            return this._tag;
        }
    }

