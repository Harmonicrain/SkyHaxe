package com.sulake.habbo.communication.messages.outgoing.catalog
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class PurchaseFromCatalogComposer implements IMessageComposer
    {
        var _array:Array<ASAny>;

        public function new(k:Int, _arg_2:Int, _arg_3:String, _arg_4:Int)
        {
            this._array = [];
            this._array.push(k);
            this._array.push(_arg_2);
            this._array.push(_arg_3);
            this._array.push(_arg_4);
        }

        public function dispose()
        {
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._array;
        }
    }

