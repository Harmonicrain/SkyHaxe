package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.HeightMapMessageParser;

     class HeightMapEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, HeightMapMessageParser);
        }

        public function getParser():HeightMapMessageParser
        {
            return Std.downcast(_parser , HeightMapMessageParser);
        }
    }

