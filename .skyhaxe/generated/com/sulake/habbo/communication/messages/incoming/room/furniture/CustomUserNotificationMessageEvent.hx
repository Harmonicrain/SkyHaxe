package com.sulake.habbo.communication.messages.incoming.room.furniture
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.furniture.CustomUserNotificationMessageParser;

     class CustomUserNotificationMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CustomUserNotificationMessageParser);
        }

        public function getParser():CustomUserNotificationMessageParser
        {
            return Std.downcast(parser , CustomUserNotificationMessageParser);
        }
    }

