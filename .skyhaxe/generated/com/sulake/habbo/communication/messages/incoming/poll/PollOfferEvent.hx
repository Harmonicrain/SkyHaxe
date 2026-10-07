package com.sulake.habbo.communication.messages.incoming.poll
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.poll.PollOfferParser;

     class PollOfferEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, PollOfferParser);
        }

        public function getParser():PollOfferParser
        {
            return Std.downcast(_parser , PollOfferParser);
        }
    }

