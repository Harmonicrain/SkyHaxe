package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.GuideSessionAttachedMessageParser;

     class GuideSessionAttachedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GuideSessionAttachedMessageParser);
        }

        public function getParser():GuideSessionAttachedMessageParser
        {
            return Std.downcast(_parser , GuideSessionAttachedMessageParser);
        }
    }

