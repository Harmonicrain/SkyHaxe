package com.sulake.habbo.communication.messages.incoming.room.layout
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.layout.RoomEntryTileMessageParser;

     class RoomEntryTileMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RoomEntryTileMessageParser);
        }

        public function getParser():RoomEntryTileMessageParser
        {
            return Std.downcast(_parser , RoomEntryTileMessageParser);
        }
    }

