package com.sulake.habbo.communication.messages.incoming.competition
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.competition.SecondsUntilMessageParser;

     class SecondsUntilMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, SecondsUntilMessageParser);
        }

        public function getParser():SecondsUntilMessageParser
        {
            return Std.downcast(_parser , SecondsUntilMessageParser);
        }
    }

