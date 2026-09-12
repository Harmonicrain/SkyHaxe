package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.trade
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class WiredTradeCancelledMessageParser implements IMessageParser
    {
        var _transactionFailureTypeId:Int = 0;
        public function flush():Bool
        {
            this._transactionFailureTypeId = 0;
            return true;
        }
        public function parse(data:IMessageDataWrapper):Bool
        {
            if (data.bytesAvailable != 4) { return false; }
            this._transactionFailureTypeId = data.readInteger();
            return true;
        }
        public var transactionFailureTypeId(get,never):Int;
public function  get_transactionFailureTypeId():Int
        { return this._transactionFailureTypeId; }

	public function new() {}
    }

