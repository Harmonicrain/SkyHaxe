package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.FaqTextMessageParser;

     class FaqTextMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, FaqTextMessageParser);
        }

        public function getParser():FaqTextMessageParser
        {
            return Std.downcast(_parser , FaqTextMessageParser);
        }
    }

