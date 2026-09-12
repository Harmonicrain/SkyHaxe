package com.sulake.habbo.communication.messages.outgoing.tracking
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class LatencyPingRequestMessageComposer implements IMessageComposer 
    {
        var _id:Int = 0;

        public function new(k:Int)
        {
            this._id = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._id];
        }

        public function dispose()
        {
        }
    }

