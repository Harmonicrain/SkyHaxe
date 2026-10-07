package com.sulake.habbo.communication.messages.incoming.competition
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.competition.CurrentTimingCodeMessageParser;

     class CurrentTimingCodeMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CurrentTimingCodeMessageParser);
        }

        public function getParser():CurrentTimingCodeMessageParser
        {
            return Std.downcast(_parser , CurrentTimingCodeMessageParser);
        }
    }

