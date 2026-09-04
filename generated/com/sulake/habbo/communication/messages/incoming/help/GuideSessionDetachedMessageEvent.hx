package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.GuideSessionDetachedMessageParser;

     class GuideSessionDetachedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GuideSessionDetachedMessageParser);
        }

        public function getParser():GuideSessionDetachedMessageParser
        {
            return Std.downcast(_parser , GuideSessionDetachedMessageParser);
        }
    }

