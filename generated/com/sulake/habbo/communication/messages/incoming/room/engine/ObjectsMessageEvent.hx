package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.ObjectsMessageParser;

     class ObjectsMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ObjectsMessageParser);
        }

        public function getParser():ObjectsMessageParser
        {
            return Std.downcast(_parser , ObjectsMessageParser);
        }
    }

