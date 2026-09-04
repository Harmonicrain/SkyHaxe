package com.sulake.habbo.communication.messages.incoming.bots
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.bots.BotAddedToInventoryParser;

     class BotAddedToInventoryEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, BotAddedToInventoryParser);
        }

        public function getParser():BotAddedToInventoryParser
        {
            return Std.downcast(_parser , BotAddedToInventoryParser);
        }
    }

