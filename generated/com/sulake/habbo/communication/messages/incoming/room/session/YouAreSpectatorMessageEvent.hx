package com.sulake.habbo.communication.messages.incoming.room.session
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.session.YouAreSpectatorMessageParser;

     class YouAreSpectatorMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, YouAreSpectatorMessageParser);
        }

        public function getParser():YouAreSpectatorMessageParser
        {
            return Std.downcast(_parser , YouAreSpectatorMessageParser);
        }
    }

