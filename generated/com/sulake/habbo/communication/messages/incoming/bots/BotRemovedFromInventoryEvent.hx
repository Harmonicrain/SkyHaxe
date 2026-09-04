package com.sulake.habbo.communication.messages.incoming.bots
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.bots.BotRemovedFromInventoryParser;

     class BotRemovedFromInventoryEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, BotRemovedFromInventoryParser);
        }

        public function getParser():BotRemovedFromInventoryParser
        {
            return Std.downcast(_parser , BotRemovedFromInventoryParser);
        }
    }

