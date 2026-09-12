package com.sulake.habbo.communication.messages.outgoing.catalog
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class SelectClubGiftComposer implements IMessageComposer
    {
        var _productCode:String;

        public function new(k:String)
        {
            this._productCode = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._productCode];
        }

        public function dispose()
        {
            this._productCode = null;
        }
    }

