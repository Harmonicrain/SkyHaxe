package com.sulake.habbo.ui.widget.messages
;
     class RoomWidgetChatTypingMessage extends RoomWidgetMessage 
    {
        public static inline final RWCTM_TYPING_STATUS= "RWCTM_TYPING_STATUS";

        var _isTyping:Bool = false;

        public function new(k:Bool)
        {
            super(RWCTM_TYPING_STATUS);
            this._isTyping = k;
        }

        public var isTyping(get,never):Bool;
public function  get_isTyping():Bool
        {
            return this._isTyping;
        }
    }

