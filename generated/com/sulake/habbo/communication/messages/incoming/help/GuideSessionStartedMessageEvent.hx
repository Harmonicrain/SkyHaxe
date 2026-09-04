package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.GuideSessionStartedMessageParser;

     class GuideSessionStartedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GuideSessionStartedMessageParser);
        }

        public function getParser():GuideSessionStartedMessageParser
        {
            return Std.downcast(_parser , GuideSessionStartedMessageParser);
        }
    }

