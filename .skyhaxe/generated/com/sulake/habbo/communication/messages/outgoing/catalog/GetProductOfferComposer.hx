package com.sulake.habbo.communication.messages.outgoing.catalog
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GetProductOfferComposer implements IMessageComposer
    {
        var _offerId:Int = 0;

        public function new(k:Int)
        {
            this._offerId = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._offerId];
        }

        public function dispose()
        {
        }
    }

