package com.sulake.habbo.communication.messages.incoming.inventory.badges
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.badges.IsBadgeRequestFulfilledParser;

     class IsBadgeRequestFulfilledEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, IsBadgeRequestFulfilledParser);
        }

        public function getParser():IsBadgeRequestFulfilledParser
        {
            return Std.downcast(_parser , IsBadgeRequestFulfilledParser);
        }
    }

