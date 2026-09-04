package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.GuideTicketCreationResultMessageParser;

     class GuideTicketCreationResultMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GuideTicketCreationResultMessageParser);
        }

        public function getParser():GuideTicketCreationResultMessageParser
        {
            return Std.downcast(_parser , GuideTicketCreationResultMessageParser);
        }
    }

