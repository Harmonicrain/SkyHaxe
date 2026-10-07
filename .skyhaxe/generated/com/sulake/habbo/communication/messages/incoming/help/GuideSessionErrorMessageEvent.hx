package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.GuideSessionErrorMessageParser;

     class GuideSessionErrorMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GuideSessionErrorMessageParser);
        }

        public function getParser():GuideSessionErrorMessageParser
        {
            return Std.downcast(_parser , GuideSessionErrorMessageParser);
        }
    }

