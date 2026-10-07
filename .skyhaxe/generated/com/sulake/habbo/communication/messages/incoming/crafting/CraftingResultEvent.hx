package com.sulake.habbo.communication.messages.incoming.crafting
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.crafting.CraftingResultMessageParser;

     class CraftingResultEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, CraftingResultMessageParser);
        }

        public function getParser():CraftingResultMessageParser
        {
            return Std.downcast(_parser , CraftingResultMessageParser);
        }
    }

