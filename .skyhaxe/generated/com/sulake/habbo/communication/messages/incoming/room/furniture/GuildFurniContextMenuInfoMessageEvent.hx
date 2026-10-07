package com.sulake.habbo.communication.messages.incoming.room.furniture
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.furniture.GuildFurniContextMenuInfoMessageParser;

     class GuildFurniContextMenuInfoMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GuildFurniContextMenuInfoMessageParser);
        }

        public function getParser():GuildFurniContextMenuInfoMessageParser
        {
            return Std.downcast(_parser , GuildFurniContextMenuInfoMessageParser);
        }
    }

