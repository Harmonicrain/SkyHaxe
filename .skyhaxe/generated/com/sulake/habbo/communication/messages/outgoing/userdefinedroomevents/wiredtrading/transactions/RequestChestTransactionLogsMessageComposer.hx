package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.wiredtrading.transactions
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

    /** July C2S 1999: visible chest id, page size, 1-based page. */
     class RequestChestTransactionLogsMessageComposer
        implements IMessageComposer implements  IDisposable
    {
        var _array:Array<ASAny>;
        public function new(
            chestId:Int, amount:Int, page:Int)
        {
            this._array = [chestId, amount, page];
        }
        public function getMessageArray():Array<ASAny> { return this._array; }
        public function dispose() { this._array = null; }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._array == null; }
    }

