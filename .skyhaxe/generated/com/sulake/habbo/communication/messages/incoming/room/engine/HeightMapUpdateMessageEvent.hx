package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.HeightMapUpdateMessageParser;

     class HeightMapUpdateMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, HeightMapUpdateMessageParser);
        }

        public function getParser():HeightMapUpdateMessageParser
        {
            return Std.downcast(_parser , HeightMapUpdateMessageParser);
        }
    }

