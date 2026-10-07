package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.ItemDataUpdateMessageParser;

     class ItemDataUpdateMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ItemDataUpdateMessageParser);
        }

        public function getParser():ItemDataUpdateMessageParser
        {
            return Std.downcast(_parser , ItemDataUpdateMessageParser);
        }
    }

