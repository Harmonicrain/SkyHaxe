package com.sulake.habbo.communication.messages.outgoing.catalog
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GetCatalogPageComposer implements IMessageComposer
    {
        var _array:Array<ASAny>;

        public function new(_pageId:Int, _offerId:Int, _catalogType:String)
        {
            this._array = [_pageId, _offerId, _catalogType];
        }

        public function dispose()
        {
            this._array = null;
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._array;
        }
    }

