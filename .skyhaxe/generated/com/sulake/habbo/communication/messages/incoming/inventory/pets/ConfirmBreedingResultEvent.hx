package com.sulake.habbo.communication.messages.incoming.inventory.pets
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.pets.ConfirmBreedingResultParser;

     class ConfirmBreedingResultEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ConfirmBreedingResultParser);
        }

        public function getParser():ConfirmBreedingResultParser
        {
            return Std.downcast(_parser , ConfirmBreedingResultParser);
        }
    }

