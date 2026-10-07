package com.sulake.habbo.communication.messages.incoming.room.session
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.session.YouArePlayingGameMessageParser;

     class YouArePlayingGameMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, YouArePlayingGameMessageParser);
        }

        public function getParser():YouArePlayingGameMessageParser
        {
            return Std.downcast(_parser , YouArePlayingGameMessageParser);
        }
    }

