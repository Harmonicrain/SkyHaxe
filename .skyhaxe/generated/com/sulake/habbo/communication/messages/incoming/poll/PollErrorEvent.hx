package com.sulake.habbo.communication.messages.incoming.poll
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.poll.PollErrorParser;

     class PollErrorEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, PollErrorParser);
        }

        public function getParser():PollErrorParser
        {
            return Std.downcast(_parser , PollErrorParser);
        }
    }

