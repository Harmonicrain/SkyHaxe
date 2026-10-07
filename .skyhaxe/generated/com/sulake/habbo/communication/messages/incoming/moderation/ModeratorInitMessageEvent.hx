package com.sulake.habbo.communication.messages.incoming.moderation
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.moderation.ModeratorInitMessageParser;

     class ModeratorInitMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ModeratorInitMessageParser);
        }

        public function getParser():ModeratorInitMessageParser
        {
            return Std.downcast(_parser , ModeratorInitMessageParser);
        }
    }

