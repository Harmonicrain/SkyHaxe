package com.sulake.habbo.communication.messages.incoming.inventory.badges
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.badges.BadgesParser;

     class BadgesEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, BadgesParser);
        }

        public function getParser():BadgesParser
        {
            return Std.downcast(_parser , BadgesParser);
        }
    }

