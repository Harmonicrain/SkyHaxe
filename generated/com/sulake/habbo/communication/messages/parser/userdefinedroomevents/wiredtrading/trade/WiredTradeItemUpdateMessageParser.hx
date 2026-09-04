package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.trade
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class WiredTradeItemUpdateMessageParser implements IMessageParser
    {
        var _tradingItems:WiredTradingItems = new WiredTradingItems();
        var _canAccept:Bool = false;
        var _extra:Int = 0;

        public function flush():Bool
        {
            this._tradingItems.flush();
            this._canAccept = false;
            this._extra = 0;
            return true;
        }
        public function parse(data:IMessageDataWrapper):Bool
        {
            if (!this._tradingItems.parse(data)) { return false; }
            if (data.bytesAvailable < 5) { return false; }
            this._canAccept = data.readBoolean();
            this._extra = data.readInteger();
            return data.bytesAvailable == 0;
        }
        public var tradingItems(get,never):WiredTradingItems;
function  get_tradingItems():WiredTradingItems { return this._tradingItems; }
        public var canAccept(get,never):Bool;
function  get_canAccept():Bool { return this._canAccept; }
        public var extra(get,never):Int;
function  get_extra():Int { return this._extra; }

	public function new() {}
    }

