package com.sulake.habbo.communication.messages.incoming.inventory.pets
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.pets.GoToBreedingNestFailureParser;

     class GoToBreedingNestFailureEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GoToBreedingNestFailureParser);
        }

        public function getParser():GoToBreedingNestFailureParser
        {
            return Std.downcast(_parser , GoToBreedingNestFailureParser);
        }
    }

