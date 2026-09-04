package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.ObjectRemoveMessageParser;

     class ObjectRemoveMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ObjectRemoveMessageParser);
        }

        public function getParser():ObjectRemoveMessageParser
        {
            return Std.downcast(_parser , ObjectRemoveMessageParser);
        }
    }

