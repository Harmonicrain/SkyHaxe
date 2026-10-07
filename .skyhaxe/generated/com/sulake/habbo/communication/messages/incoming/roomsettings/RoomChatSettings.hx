package com.sulake.habbo.communication.messages.incoming.roomsettings
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomChatSettings 
    {
        public static inline final CHAT_MODE_FREE_FLOW= 0;
        public static inline final CHAT_MODE_LINE_BY_LINE= 1;
        public static inline final CHAT_BUBBLE_WIDTH_WIDE= 0;
        public static inline final CHAT_BUBBLE_WIDTH_NORMAL= 1;
        public static inline final CHAT_BUBBLE_WIDTH_THIN= 2;
        public static inline final CHAT_SCROLL_SPEED_FAST= 0;
        public static inline final CHAT_SCROLL_SPEED_NORMAL= 1;
        public static inline final CHAT_SCROLL_SPEED_SLOW= 2;
        public static inline final FLOOD_FILTER_STRICT= 0;
        public static inline final FLOOD_FILTER_NORMAL= 1;
        public static inline final FLOOD_FILTER_LOOSE= 2;

        var _mode:Int = 0;
        var _bubbleWidth:Int = 1;
        var _scrollSpeed:Int = 1;
        var _floodSensitivity:Int = 1;
        var _fullHearRange:Int = 14;

        public function new(k:IMessageDataWrapper)
        {
            this._mode = k.readInteger();
            this._bubbleWidth = k.readInteger();
            this._scrollSpeed = k.readInteger();
            this._fullHearRange = k.readInteger();
            this._floodSensitivity = k.readInteger();
        }

        public var mode(get,never):Int;
public function  get_mode():Int
        {
            return this._mode;
        }

        public var bubbleWidth(get,never):Int;
public function  get_bubbleWidth():Int
        {
            return this._bubbleWidth;
        }

        public var scrollSpeed(get,never):Int;
public function  get_scrollSpeed():Int
        {
            return this._scrollSpeed;
        }

        public var fullHearRange(get,never):Int;
public function  get_fullHearRange():Int
        {
            return this._fullHearRange;
        }

        public var floodSensitivity(get,never):Int;
public function  get_floodSensitivity():Int
        {
            return this._floodSensitivity;
        }
    }

