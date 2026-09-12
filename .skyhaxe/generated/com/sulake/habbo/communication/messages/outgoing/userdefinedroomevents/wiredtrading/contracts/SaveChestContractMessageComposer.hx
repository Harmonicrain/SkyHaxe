package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.contracts
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class SaveChestContractMessageComposer implements IMessageComposer
    {
        var _data:Array<ASAny>;
        public function new(data:Array<ASAny>)
        {
            this._data = data == null ? [] : data;
        }
        public function getMessageArray():Array<ASAny> { return this._data; }
        public function dispose() { this._data = null; }
    }

