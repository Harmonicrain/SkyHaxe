package com.sulake.habbo.communication.messages.outgoing.inventory.trading
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class AddItemsToTradeComposer implements IMessageComposer
    {
        var _array:Array<ASAny>;

        public function new(k:Vector<Int>)
        {
            var _local_2 = 0;
            this._array = new Array<ASAny>();
            this._array.push(k.length);
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = _tmp_;
                this._array.push(_local_2);
            }
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._array;
        }

        public function dispose()
        {
        }
    }

