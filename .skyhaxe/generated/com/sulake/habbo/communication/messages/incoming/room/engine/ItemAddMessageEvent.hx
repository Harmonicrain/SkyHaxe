package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.ItemAddMessageParser;

     class ItemAddMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ItemAddMessageParser);
        }

        public function getParser():ItemAddMessageParser
        {
            return Std.downcast(_parser , ItemAddMessageParser);
        }
    }

