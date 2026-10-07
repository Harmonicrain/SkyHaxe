package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.RoomPropertyMessageParser;

     class RoomPropertyMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RoomPropertyMessageParser);
        }

        public function getParser():RoomPropertyMessageParser
        {
            return Std.downcast(_parser , RoomPropertyMessageParser);
        }
    }

