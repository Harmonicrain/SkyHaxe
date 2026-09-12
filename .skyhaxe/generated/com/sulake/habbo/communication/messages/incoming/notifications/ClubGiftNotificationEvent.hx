package com.sulake.habbo.communication.messages.incoming.notifications
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.notifications.ClubGiftNotificationParser;

     class ClubGiftNotificationEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ClubGiftNotificationParser);
        }

        public function getParser():ClubGiftNotificationParser
        {
            return Std.downcast(_parser , ClubGiftNotificationParser);
        }
    }

