package com.sulake.habbo.communication.messages.outgoing.room.furniture
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class SetRandomStateMessageComposer implements IMessageComposer
    {
        var _objectId:Int = 0;
        var _param:Int = 0;

        public function new(k:Int, _arg_2:Int=0)
        {
            this._objectId = k;
            this._param = _arg_2;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._objectId, this._param];
        }
    }

