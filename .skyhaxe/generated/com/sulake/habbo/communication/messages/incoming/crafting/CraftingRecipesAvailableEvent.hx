package com.sulake.habbo.communication.messages.incoming.crafting
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.crafting.CraftingRecipesAvailableMessageParser;

     class CraftingRecipesAvailableEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, CraftingRecipesAvailableMessageParser);
        }

        public function getParser():CraftingRecipesAvailableMessageParser
        {
            return Std.downcast(_parser , CraftingRecipesAvailableMessageParser);
        }
    }

