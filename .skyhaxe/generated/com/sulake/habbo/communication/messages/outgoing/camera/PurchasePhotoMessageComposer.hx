package com.sulake.habbo.communication.messages.outgoing.camera
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class PurchasePhotoMessageComposer implements IMessageComposer 
    {
        var _data:Array<ASAny>;

        public function new()
        {
            this._data = [];
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._data;
        }

        public function dispose()
        {
            this._data = [];
        }
    }

