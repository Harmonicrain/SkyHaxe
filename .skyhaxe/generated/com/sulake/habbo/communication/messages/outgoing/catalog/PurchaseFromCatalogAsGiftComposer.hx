package com.sulake.habbo.communication.messages.outgoing.catalog
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class PurchaseFromCatalogAsGiftComposer implements IMessageComposer
    {
        var _array:Array<ASAny>;

        public function new(pageId:Int, offerCode:Int, extraParam:String, receiverName:String, message:String, boxStuffTypeId:Int, boxTypeId:Int, ribbonTypeId:Int, showPurchaserName:Bool)
        {
            this._array = [];
            this._array.push(pageId);
            this._array.push(offerCode);
            this._array.push(extraParam);
            this._array.push(receiverName);
            this._array.push(message);
            this._array.push(boxStuffTypeId);
            this._array.push(boxTypeId);
            this._array.push(ribbonTypeId);
            this._array.push(showPurchaserName);
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

