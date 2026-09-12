package com.sulake.habbo.communication.messages.outgoing.marketplace
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class GetMarketplaceItemStatsComposer implements IMessageComposer implements  IDisposable
    {
        var _array:Array<ASAny>;

        public function new(itemType:Int, itemId:Int)
        {
            this._array = new Array<ASAny>();
            this._array.push(itemType);
            this._array.push(itemId);
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._array;
        }

        public function dispose()
        {
            this._array = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return false;
        }
    }

