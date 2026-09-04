package com.sulake.habbo.communication.messages.incoming.poll
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.poll.PollContentsParser;

     class PollContentsEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, PollContentsParser);
        }

        public function getParser():PollContentsParser
        {
            return Std.downcast(_parser , PollContentsParser);
        }
    }

