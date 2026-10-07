package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.QuizResultsMessageParser;

     class QuizResultsMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, QuizResultsMessageParser);
        }

        public function getParser():QuizResultsMessageParser
        {
            return Std.downcast(_parser , QuizResultsMessageParser);
        }
    }

