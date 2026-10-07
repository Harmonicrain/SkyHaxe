package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.GuideTicketResolutionMessageParser;

     class GuideTicketResolutionMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GuideTicketResolutionMessageParser);
        }

        public function getParser():GuideTicketResolutionMessageParser
        {
            return Std.downcast(_parser , GuideTicketResolutionMessageParser);
        }
    }

