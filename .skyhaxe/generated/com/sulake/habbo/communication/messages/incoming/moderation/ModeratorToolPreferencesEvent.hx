package com.sulake.habbo.communication.messages.incoming.moderation
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.moderation.ModeratorToolPreferencesMessageParser;

     class ModeratorToolPreferencesEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ModeratorToolPreferencesMessageParser);
        }

        public function getParser():ModeratorToolPreferencesMessageParser
        {
            return Std.downcast(parser , ModeratorToolPreferencesMessageParser);
        }
    }

