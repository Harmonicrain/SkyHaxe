package com.sulake.habbo.communication.messages.incoming.poll
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.poll.QuestionFinishedParser;

     class QuestionFinishedEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, QuestionFinishedParser);
        }

        public function getParser():QuestionFinishedParser
        {
            return Std.downcast(_parser , QuestionFinishedParser);
        }
    }

