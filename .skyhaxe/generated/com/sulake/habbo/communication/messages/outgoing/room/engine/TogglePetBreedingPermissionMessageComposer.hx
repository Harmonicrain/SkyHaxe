package com.sulake.habbo.communication.messages.outgoing.room.engine
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class TogglePetBreedingPermissionMessageComposer implements IMessageComposer
    {
        var _petId:Int = 0;

        public function new(k:Int)
        {
            this._petId = k;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._petId];
        }
    }

