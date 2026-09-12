package com.sulake.habbo.communication.messages.outgoing.room.engine
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class MountPetMessageComposer implements IMessageComposer
    {
        var _petId:Int = 0;
        var _mounted:Bool = false;

        public function new(k:Int, _arg_2:Bool)
        {
            this._petId = k;
            this._mounted = _arg_2;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._petId, this._mounted];
        }
    }

