package com.sulake.habbo.communication.messages.incoming.room.layout
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.layout.RoomOccupiedTilesMessageParser;

     class RoomOccupiedTilesMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RoomOccupiedTilesMessageParser);
        }

        public function getParser():RoomOccupiedTilesMessageParser
        {
            return Std.downcast(_parser , RoomOccupiedTilesMessageParser);
        }
    }

