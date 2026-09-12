package com.sulake.habbo.communication.messages.incoming.moderation
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.moderation.ModeratorMessageParser;

     class ModeratorMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ModeratorMessageParser);
        }

        public function getParser():ModeratorMessageParser
        {
            return Std.downcast(_parser , ModeratorMessageParser);
        }
    }

