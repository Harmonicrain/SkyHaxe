package com.sulake.habbo.communication.messages.incoming.poll
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.poll.QuestionAnsweredParser;

     class QuestionAnsweredEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, QuestionAnsweredParser);
        }

        public function getParser():QuestionAnsweredParser
        {
            return Std.downcast(_parser , QuestionAnsweredParser);
        }
    }

