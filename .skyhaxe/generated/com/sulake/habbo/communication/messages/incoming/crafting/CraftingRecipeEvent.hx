package com.sulake.habbo.communication.messages.incoming.crafting
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.crafting.CraftingRecipeMessageParser;

     class CraftingRecipeEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, CraftingRecipeMessageParser);
        }

        public function getParser():CraftingRecipeMessageParser
        {
            return Std.downcast(_parser , CraftingRecipeMessageParser);
        }
    }

