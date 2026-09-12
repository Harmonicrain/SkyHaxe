package com.sulake.habbo.communication.messages.incoming.room.chat
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.chat.RoomChatSettingsMessageParser;

     class RoomChatSettingsMessageEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, RoomChatSettingsMessageParser);
        }

        public function getParser():RoomChatSettingsMessageParser
        {
            return Std.downcast(_parser , RoomChatSettingsMessageParser);
        }
    }

