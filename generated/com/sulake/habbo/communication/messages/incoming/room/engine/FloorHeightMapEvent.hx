package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.FloorHeightMapMessageParser;

     class FloorHeightMapEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, FloorHeightMapMessageParser);
        }

        public function getParser():FloorHeightMapMessageParser
        {
            return Std.downcast(_parser , FloorHeightMapMessageParser);
        }
    }

