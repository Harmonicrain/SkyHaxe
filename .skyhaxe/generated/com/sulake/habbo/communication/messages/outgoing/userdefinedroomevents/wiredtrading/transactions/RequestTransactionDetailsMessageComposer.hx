package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.transactions
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.communication.util.Long;
    import com.sulake.core.runtime.IDisposable;

    /** July C2S 475: one 64-bit transaction id. */
     class RequestTransactionDetailsMessageComposer
        implements IMessageComposer implements  IDisposable
    {
        var _array:Array<ASAny>;
        public function new(transactionId:Float)
        {
            this._array = [new Long(transactionId)];
        }
        public function getMessageArray():Array<ASAny> { return this._array; }
        public function dispose() { this._array = null; }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._array == null; }
    }

