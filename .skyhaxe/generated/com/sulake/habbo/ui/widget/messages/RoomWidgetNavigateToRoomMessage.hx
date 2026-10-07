package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetNavigateToRoomMessage extends RoomWidgetMessage 
    {
        public static inline final RWGOI_MESSAGE_NAVIGATE_TO_ROOM= "RWGOI_MESSAGE_NAVIGATE_TO_ROOM";
        public static inline final RWGOI_MESSAGE_NAVIGATE_HOME= "RWGOI_MESSAGE_NAVIGATE_HOME";

        var _roomId:Int = 0;

        public function new(k:String, _arg_2:Int=-1)
        {
            super(k);
            this._roomId = _arg_2;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }
    }

