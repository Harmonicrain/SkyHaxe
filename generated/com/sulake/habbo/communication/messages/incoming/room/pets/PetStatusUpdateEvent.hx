package com.sulake.habbo.communication.messages.incoming.room.pets
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.pets.PetStatusUpdateParser;

     class PetStatusUpdateEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, PetStatusUpdateParser);
        }

        public function getParser():PetStatusUpdateParser
        {
            return Std.downcast(_parser , PetStatusUpdateParser);
        }
    }

