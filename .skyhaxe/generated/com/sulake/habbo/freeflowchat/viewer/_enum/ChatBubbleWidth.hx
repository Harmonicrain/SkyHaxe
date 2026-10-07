package com.sulake.habbo.freeflowchat.viewer._enum
;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.RoomChatSettings;

     class ChatBubbleWidth 
    {
        public static inline final NORMAL= 350;
        public static inline final THIN= 240;
        public static inline final WIDE= 2000;


        public static function fromValue(k:Int):Int
        {
            switch (k)
            {
                case RoomChatSettings.CHAT_BUBBLE_WIDTH_NORMAL:
                    return ChatBubbleWidth.NORMAL;
                case RoomChatSettings.CHAT_BUBBLE_WIDTH_THIN:
                    return ChatBubbleWidth.THIN;
                case RoomChatSettings.CHAT_BUBBLE_WIDTH_WIDE:
                    return ChatBubbleWidth.WIDE;
            }
            return NORMAL;
        }

	public function new() {}
    }

