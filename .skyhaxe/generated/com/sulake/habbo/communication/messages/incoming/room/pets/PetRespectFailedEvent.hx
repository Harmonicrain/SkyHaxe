package com.sulake.habbo.communication.messages.incoming.room.pets
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.pets.PetRespectFailedParser;

     class PetRespectFailedEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, PetRespectFailedParser);
        }

        public function getParser():PetRespectFailedParser
        {
            return Std.downcast(_parser , PetRespectFailedParser);
        }
    }

