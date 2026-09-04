package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.PublicRoomObjectsMessageParser;

     class PublicRoomObjectsMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, PublicRoomObjectsMessageParser);
        }

        public function getParser():PublicRoomObjectsMessageParser
        {
            return Std.downcast(_parser , PublicRoomObjectsMessageParser);
        }
    }

