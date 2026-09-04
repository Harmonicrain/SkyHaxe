package com.sulake.habbo.communication.messages.incoming.inventory.pets
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.pets.ConfirmBreedingRequestParser;

     class ConfirmBreedingRequestEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ConfirmBreedingRequestParser);
        }

        public function getParser():ConfirmBreedingRequestParser
        {
            return Std.downcast(_parser , ConfirmBreedingRequestParser);
        }
    }

