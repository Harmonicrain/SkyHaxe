package com.sulake.habbo.communication.messages.incoming.room.furniture
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.furniture.RoomDimmerPresetsMessageParser;

     class RoomDimmerPresetsEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, RoomDimmerPresetsMessageParser);
        }

        public function getParser():RoomDimmerPresetsMessageParser
        {
            return Std.downcast(_parser , RoomDimmerPresetsMessageParser);
        }
    }

