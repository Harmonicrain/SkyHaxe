package com.sulake.habbo.communication.messages.outgoing.inventory.trading
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class RemoveItemFromTradeComposer implements IMessageComposer
    {
        var _itemID:Int = 0;

        public function new(k:Int)
        {
            this._itemID = k;
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._itemID];
        }
    }

