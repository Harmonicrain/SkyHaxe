package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.FavouriteMembershipUpdateMessageParser;

     class FavoriteMembershipUpdateMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, FavouriteMembershipUpdateMessageParser);
        }

        public function getParser():FavouriteMembershipUpdateMessageParser
        {
            return Std.downcast(_parser , FavouriteMembershipUpdateMessageParser);
        }
    }

