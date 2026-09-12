package com.sulake.habbo.communication.messages.outgoing.catalog
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GetIsOfferGiftableComposer implements IMessageComposer
    {
        var _array:Array<ASAny>;

        public function new(k:Int)
        {
            this._array = [];
            this._array.push(k);
        }

        public function dispose()
        {
            this._array = [];
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._array;
        }
    }

