package com.sulake.habbo.communication.messages.incoming.room.session
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.session.RoomForwardMessageParser;

     class RoomForwardMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RoomForwardMessageParser);
        }

        public function getParser():RoomForwardMessageParser
        {
            return Std.downcast(_parser , RoomForwardMessageParser);
        }
    }

