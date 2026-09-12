package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.PetSupplementedNotificationParser;

     class PetSupplementedNotificationEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, PetSupplementedNotificationParser);
        }

        public function getParser():PetSupplementedNotificationParser
        {
            return Std.downcast(_parser , PetSupplementedNotificationParser);
        }
    }

