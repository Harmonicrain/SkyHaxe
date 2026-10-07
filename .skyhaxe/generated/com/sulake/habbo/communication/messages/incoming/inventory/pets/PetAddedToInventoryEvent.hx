package com.sulake.habbo.communication.messages.incoming.inventory.pets
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.pets.PetAddedToInventoryParser;

     class PetAddedToInventoryEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, PetAddedToInventoryParser);
        }

        public function getParser():PetAddedToInventoryParser
        {
            return Std.downcast(_parser , PetAddedToInventoryParser);
        }
    }

