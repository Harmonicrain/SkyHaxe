package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.FaqClientFaqsMessageParser;

     class FaqClientFaqsMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, FaqClientFaqsMessageParser);
        }

        public function getParser():FaqClientFaqsMessageParser
        {
            return Std.downcast(_parser , FaqClientFaqsMessageParser);
        }
    }

