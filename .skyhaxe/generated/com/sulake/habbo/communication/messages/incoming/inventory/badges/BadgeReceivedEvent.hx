package com.sulake.habbo.communication.messages.incoming.inventory.badges
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.badges.BadgeReceivedParser;

     class BadgeReceivedEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, BadgeReceivedParser);
        }

        public function getParser():BadgeReceivedParser
        {
            return Std.downcast(_parser , BadgeReceivedParser);
        }
    }

