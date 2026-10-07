package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.ObjectAddMessageParser;

     class ObjectAddMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ObjectAddMessageParser);
        }

        public function getParser():ObjectAddMessageParser
        {
            return Std.downcast(_parser , ObjectAddMessageParser);
        }
    }

