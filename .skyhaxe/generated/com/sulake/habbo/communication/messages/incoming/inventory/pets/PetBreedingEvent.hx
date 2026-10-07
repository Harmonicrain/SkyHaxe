package com.sulake.habbo.communication.messages.incoming.inventory.pets
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.pets.PetBreedingMessageParser;

     class PetBreedingEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, PetBreedingMessageParser);
        }

        public function getParser():PetBreedingMessageParser
        {
            return Std.downcast(_parser , PetBreedingMessageParser);
        }
    }

