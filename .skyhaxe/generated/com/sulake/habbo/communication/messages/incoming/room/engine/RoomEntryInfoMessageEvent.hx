package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.RoomEntryInfoMessageParser;

     class RoomEntryInfoMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RoomEntryInfoMessageParser);
        }

        public function getParser():RoomEntryInfoMessageParser
        {
            return Std.downcast(_parser , RoomEntryInfoMessageParser);
        }
    }

