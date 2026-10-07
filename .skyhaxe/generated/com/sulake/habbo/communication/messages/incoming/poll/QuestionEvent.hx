package com.sulake.habbo.communication.messages.incoming.poll
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.poll.QuestionParser;

     class QuestionEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, QuestionParser);
        }

        public function getParser():QuestionParser
        {
            return Std.downcast(_parser , QuestionParser);
        }
    }

