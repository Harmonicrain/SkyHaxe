package com.sulake.habbo.communication.messages.incoming.moderation
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.moderation.CfhChatlogMessageParser;

     class CfhChatlogEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CfhChatlogMessageParser);
        }

        public function getParser():CfhChatlogMessageParser
        {
            return Std.downcast(_parser , CfhChatlogMessageParser);
        }
    }

