package com.sulake.habbo.communication.messages.incoming.room.session
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.session.RoomQueueStatusMessageParser;

     class RoomQueueStatusMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RoomQueueStatusMessageParser);
        }

        public function getParser():RoomQueueStatusMessageParser
        {
            return Std.downcast(_parser , RoomQueueStatusMessageParser);
        }
    }

