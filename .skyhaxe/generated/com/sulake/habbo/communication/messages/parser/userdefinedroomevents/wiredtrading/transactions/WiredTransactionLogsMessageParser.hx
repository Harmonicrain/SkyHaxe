package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.transactions
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions.WiredTransactionLogPage;

     class WiredTransactionLogsMessageParser implements IMessageParser
    {
        var _page:WiredTransactionLogPage;
        public function flush():Bool { this._page = null; return true; }
        public function parse(data:IMessageDataWrapper):Bool
        {
            var parsed= false;
            try
            {
                this._page = new WiredTransactionLogPage(data);
                parsed = data.bytesAvailable == 0;
            }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);             {
                this._page = null;
            }
 }            return parsed;
        }
        public var page(get,never):WiredTransactionLogPage;
public function  get_page():WiredTransactionLogPage { return this._page; }

	public function new() {}
    }

