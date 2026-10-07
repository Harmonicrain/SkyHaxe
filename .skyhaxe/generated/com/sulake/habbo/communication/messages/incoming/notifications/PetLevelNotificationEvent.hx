package com.sulake.habbo.communication.messages.incoming.notifications
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.notifications.PetLevelNotificationParser;

     class PetLevelNotificationEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, PetLevelNotificationParser);
        }

        public function getParser():PetLevelNotificationParser
        {
            return Std.downcast(_parser , PetLevelNotificationParser);
        }
    }

