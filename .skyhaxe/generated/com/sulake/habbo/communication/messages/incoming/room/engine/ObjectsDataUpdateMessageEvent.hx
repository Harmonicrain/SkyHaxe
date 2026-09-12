package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.ObjectsDataUpdateMessageParser;

     class ObjectsDataUpdateMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ObjectsDataUpdateMessageParser);
        }

        public function getParser():ObjectsDataUpdateMessageParser
        {
            return Std.downcast(_parser , ObjectsDataUpdateMessageParser);
        }
    }

