package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.FurnitureAliasesMessageParser;

     class FurnitureAliasesMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, FurnitureAliasesMessageParser);
        }

        public function getParser():FurnitureAliasesMessageParser
        {
            return Std.downcast(_parser , FurnitureAliasesMessageParser);
        }
    }

