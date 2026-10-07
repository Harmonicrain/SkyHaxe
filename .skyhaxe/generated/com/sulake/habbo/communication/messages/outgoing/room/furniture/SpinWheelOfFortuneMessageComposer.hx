package com.sulake.habbo.communication.messages.outgoing.room.furniture
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class SpinWheelOfFortuneMessageComposer implements IMessageComposer
    {
        var _objectId:Int = 0;

        public function new(k:Int)
        {
            this._objectId = k;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._objectId];
        }
    }

