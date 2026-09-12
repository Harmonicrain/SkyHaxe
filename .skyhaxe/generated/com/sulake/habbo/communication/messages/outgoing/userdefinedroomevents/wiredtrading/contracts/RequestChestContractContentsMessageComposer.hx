package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.contracts
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class RequestChestContractContentsMessageComposer implements IMessageComposer
    {
        var _data:Array<ASAny>;
        public function new(contractId:Int)
        {
            this._data = [contractId];
        }
        public function getMessageArray():Array<ASAny> { return this._data; }
        public function dispose() { this._data = null; }
    }

