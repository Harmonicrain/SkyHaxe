package com.sulake.habbo.communication.messages.incoming.room.chat
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.chat.RoomFilterSettingsMessageParser;

     class RoomFilterSettingsMessageEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, RoomFilterSettingsMessageParser);
        }

        public function getParser():RoomFilterSettingsMessageParser
        {
            return Std.downcast(_parser , RoomFilterSettingsMessageParser);
        }
    }

