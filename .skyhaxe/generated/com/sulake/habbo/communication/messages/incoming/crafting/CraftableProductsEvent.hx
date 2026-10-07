package com.sulake.habbo.communication.messages.incoming.crafting
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.crafting.CraftableProductsMessageParser;

     class CraftableProductsEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, CraftableProductsMessageParser);
        }

        public function getParser():CraftableProductsMessageParser
        {
            return Std.downcast(_parser , CraftableProductsMessageParser);
        }
    }

