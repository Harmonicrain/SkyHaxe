package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.ItemsMessageParser;

     class ItemsEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, ItemsMessageParser);
        }

        public function getParser():ItemsMessageParser
        {
            return Std.downcast(_parser , ItemsMessageParser);
        }
    }

