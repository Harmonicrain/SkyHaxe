package com.sulake.habbo.communication.messages.outgoing.room.pets
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class PetSelectedMessageComposer implements IMessageComposer
    {
        var _petId:Int = 0;

        public function new(k:Int)
        {
            this._petId = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._petId];
        }

        public function dispose()
        {
        }
    }

