package com.sulake.habbo.communication.messages.incoming.inventory.pets
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.pets.PetRemovedFromInventoryParser;

     class PetRemovedFromInventoryEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, PetRemovedFromInventoryParser);
        }

        public function getParser():PetRemovedFromInventoryParser
        {
            return Std.downcast(_parser , PetRemovedFromInventoryParser);
        }
    }

