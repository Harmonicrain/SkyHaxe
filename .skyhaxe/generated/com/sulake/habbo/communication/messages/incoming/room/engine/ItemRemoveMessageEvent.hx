package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.ItemRemoveMessageParser;

     class ItemRemoveMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ItemRemoveMessageParser);
        }

        public function getParser():ItemRemoveMessageParser
        {
            return Std.downcast(_parser , ItemRemoveMessageParser);
        }
    }

