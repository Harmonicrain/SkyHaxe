package com.sulake.habbo.communication.messages.incoming.room.pets
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.pets.PetTrainingPanelMessageParser;

     class PetTrainingPanelEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, PetTrainingPanelMessageParser);
        }

        public function getParser():PetTrainingPanelMessageParser
        {
            return Std.downcast(_parser , PetTrainingPanelMessageParser);
        }
    }

