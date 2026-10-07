package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.FaqCategoriesMessageParser;

     class FaqCategoriesMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, FaqCategoriesMessageParser);
        }

        public function getParser():FaqCategoriesMessageParser
        {
            return Std.downcast(_parser , FaqCategoriesMessageParser);
        }
    }

