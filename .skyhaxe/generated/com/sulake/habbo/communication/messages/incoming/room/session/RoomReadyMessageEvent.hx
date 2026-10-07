package com.sulake.habbo.communication.messages.incoming.room.session
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.session.RoomReadyMessageParser;

     class RoomReadyMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RoomReadyMessageParser);
        }

        public function getParser():RoomReadyMessageParser
        {
            return Std.downcast(_parser , RoomReadyMessageParser);
        }
    }

