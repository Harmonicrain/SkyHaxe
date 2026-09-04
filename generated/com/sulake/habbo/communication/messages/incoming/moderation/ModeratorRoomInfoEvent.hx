package com.sulake.habbo.communication.messages.incoming.moderation
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.moderation.ModeratorRoomInfoMessageParser;

     class ModeratorRoomInfoEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ModeratorRoomInfoMessageParser);
        }

        public function getParser():ModeratorRoomInfoMessageParser
        {
            return Std.downcast(_parser , ModeratorRoomInfoMessageParser);
        }
    }

