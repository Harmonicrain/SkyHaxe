package com.sulake.habbo.communication.messages.incoming.room.pets
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.pets.PetExperienceParser;

     class PetExperienceEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, PetExperienceParser);
        }

        public function getParser():PetExperienceParser
        {
            return Std.downcast(_parser , PetExperienceParser);
        }
    }

