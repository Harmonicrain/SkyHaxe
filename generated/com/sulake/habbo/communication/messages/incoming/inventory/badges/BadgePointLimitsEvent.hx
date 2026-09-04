package com.sulake.habbo.communication.messages.incoming.inventory.badges
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.badges.BadgePointLimitsParser;

     class BadgePointLimitsEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, BadgePointLimitsParser);
        }

        public function getParser():BadgePointLimitsParser
        {
            return Std.downcast(_parser , BadgePointLimitsParser);
        }
    }

