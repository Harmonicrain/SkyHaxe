package com.sulake.habbo.communication.messages.incoming.inventory.pets
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.pets.NestBreedingSuccessParser;

     class NestBreedingSuccessEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, NestBreedingSuccessParser);
        }

        public function getParser():NestBreedingSuccessParser
        {
            return Std.downcast(_parser , NestBreedingSuccessParser);
        }
    }

