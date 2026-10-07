package com.sulake.habbo.communication.messages.outgoing.room.furniture
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class OpenPetPackageMessageComposer implements IMessageComposer
    {
        var _objectId:Int = 0;
        var _petName:String;

        public function new(k:Int, _arg_2:String)
        {
            this._objectId = k;
            this._petName = _arg_2;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._objectId, this._petName];
        }

        public function dispose()
        {
        }
    }

