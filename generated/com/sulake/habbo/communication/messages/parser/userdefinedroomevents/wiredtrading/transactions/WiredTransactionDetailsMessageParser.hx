package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.transactions
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionDetails;

     class WiredTransactionDetailsMessageParser implements IMessageParser
    {
        var _details:WiredTransactionDetails;
        public function flush():Bool { this._details = null; return true; }
        public function parse(data:IMessageDataWrapper):Bool
        {
            var parsed= false;
            try
            {
                this._details = new WiredTransactionDetails(data);
                parsed = data.bytesAvailable == 0;
            }
            catch (error:ASError)
            {
                this._details = null;
            }
            return parsed;
        }
        public var details(get,never):WiredTransactionDetails;
function  get_details():WiredTransactionDetails { return this._details; }

	public function new() {}
    }

