package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.ObjectDataUpdateMessageParser;

     class ObjectDataUpdateMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ObjectDataUpdateMessageParser);
        }

        public function getParser():ObjectDataUpdateMessageParser
        {
            return Std.downcast(_parser , ObjectDataUpdateMessageParser);
        }
    }

