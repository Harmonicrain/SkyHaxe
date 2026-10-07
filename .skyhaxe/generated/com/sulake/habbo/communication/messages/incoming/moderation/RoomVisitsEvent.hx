package com.sulake.habbo.communication.messages.incoming.moderation
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.moderation.RoomVisitsMessageParser;

     class RoomVisitsEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RoomVisitsMessageParser);
        }

        public function getParser():RoomVisitsMessageParser
        {
            return Std.downcast(_parser , RoomVisitsMessageParser);
        }
    }

