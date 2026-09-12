package com.sulake.habbo.communication.messages.outgoing.tickets
;
    import com.sulake.core.communication.messages.IMessageComposer;

     final class BuyTicketsComposer implements IMessageComposer
    {
        var _message:Array<ASAny>;

        public function new(bundleId:Int, recipient:String)
        {
            this._message = [bundleId, recipient == null ? "" : recipient];
        }

        public function getMessageArray():Array<ASAny> { return this._message; }
        public function dispose() { this._message = null; }
    }

