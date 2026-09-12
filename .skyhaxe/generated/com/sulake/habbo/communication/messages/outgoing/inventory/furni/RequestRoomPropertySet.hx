package com.sulake.habbo.communication.messages.outgoing.inventory.furni
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class RequestRoomPropertySet implements IMessageComposer
    {
        var _stripId:Int = 0;

        public function new(k:Int)
        {
            this._stripId = k;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            var k= new Array<ASAny>();
            k.push(this._stripId);
            return k;
        }
    }

