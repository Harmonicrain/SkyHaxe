package com.sulake.habbo.communication.messages.incoming.inventory.pets
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.pets.PetReceivedMessageParser;

     class PetReceivedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, PetReceivedMessageParser);
        }

        public function getParser():PetReceivedMessageParser
        {
            return Std.downcast(_parser , PetReceivedMessageParser);
        }
    }

