package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.QuizDataMessageParser;

     class QuizDataMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, QuizDataMessageParser);
        }

        public function getParser():QuizDataMessageParser
        {
            return Std.downcast(_parser , QuizDataMessageParser);
        }
    }

