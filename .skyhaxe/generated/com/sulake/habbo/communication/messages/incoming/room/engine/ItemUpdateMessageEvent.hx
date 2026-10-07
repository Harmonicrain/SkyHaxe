package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.ItemUpdateMessageParser;

     class ItemUpdateMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ItemUpdateMessageParser);
        }

        public function getParser():ItemUpdateMessageParser
        {
            return Std.downcast(_parser , ItemUpdateMessageParser);
        }
    }

