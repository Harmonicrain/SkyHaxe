package com.sulake.habbo.communication.messages.outgoing.habbicons
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class BuyHabbiconCollectionMessageComposer implements IMessageComposer
    {
        var _collectionId:Int = 0;

        public function new(collectionId:Int)
        {
            this._collectionId = collectionId;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._collectionId];
        }

        public function dispose()
        {
        }
    }

