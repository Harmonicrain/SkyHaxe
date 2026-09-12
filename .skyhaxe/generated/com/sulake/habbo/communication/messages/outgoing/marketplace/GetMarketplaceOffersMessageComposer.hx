package com.sulake.habbo.communication.messages.outgoing.marketplace
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class GetMarketplaceOffersMessageComposer implements IMessageComposer implements  IDisposable
    {
        var _array:Array<ASAny>;

        public function new(k:Int, _arg_2:Int, _arg_3:String, _arg_4:Int)
        {
            this._array = new Array<ASAny>();
            this._array.push(k);
            this._array.push(_arg_2);
            this._array.push(_arg_3);
            this._array.push(_arg_4);
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

