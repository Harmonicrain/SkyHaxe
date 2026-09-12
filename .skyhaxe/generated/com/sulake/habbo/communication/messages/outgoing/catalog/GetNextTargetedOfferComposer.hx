package com.sulake.habbo.communication.messages.outgoing.catalog
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GetNextTargetedOfferComposer implements IMessageComposer
    {
        var _array:Array<ASAny>;

        public function new()
        {
            this._array = [];
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._array;
        }

        public function dispose()
        {
            this._array = null;
        }
    }

