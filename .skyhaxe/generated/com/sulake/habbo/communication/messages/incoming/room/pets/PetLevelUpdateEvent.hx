package com.sulake.habbo.communication.messages.incoming.room.pets
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.pets.PetLevelUpdateMessageParser;

     class PetLevelUpdateEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, PetLevelUpdateMessageParser);
        }

        public function getParser():PetLevelUpdateMessageParser
        {
            return Std.downcast(_parser , PetLevelUpdateMessageParser);
        }
    }

