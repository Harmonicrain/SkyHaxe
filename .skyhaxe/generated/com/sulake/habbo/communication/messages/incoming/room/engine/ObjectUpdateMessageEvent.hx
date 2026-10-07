package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.ObjectUpdateMessageParser;

     class ObjectUpdateMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ObjectUpdateMessageParser);
        }

        public function getParser():ObjectUpdateMessageParser
        {
            return Std.downcast(_parser , ObjectUpdateMessageParser);
        }
    }

