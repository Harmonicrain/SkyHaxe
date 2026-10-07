package com.sulake.habbo.communication.messages.incoming.moderation
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.moderation.ModeratorActionResultMessageParser;

     class ModeratorActionResultMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ModeratorActionResultMessageParser);
        }

        public function getParser():ModeratorActionResultMessageParser
        {
            return Std.downcast(_parser , ModeratorActionResultMessageParser);
        }
    }

