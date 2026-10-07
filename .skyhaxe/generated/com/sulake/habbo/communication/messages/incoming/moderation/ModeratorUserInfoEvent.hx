package com.sulake.habbo.communication.messages.incoming.moderation
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.moderation.ModeratorUserInfoMessageParser;

     class ModeratorUserInfoEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ModeratorUserInfoMessageParser);
        }

        public function getParser():ModeratorUserInfoMessageParser
        {
            return Std.downcast(_parser , ModeratorUserInfoMessageParser);
        }
    }

