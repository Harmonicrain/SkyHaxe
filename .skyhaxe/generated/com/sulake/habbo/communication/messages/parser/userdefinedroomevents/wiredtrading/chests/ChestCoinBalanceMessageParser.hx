package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class ChestCoinBalanceMessageParser implements IMessageParser
    {
        var _chestId:Int = 0;
        var _coins:Int = 0;
        var _update:Bool = false;
        public function flush():Bool
        {
            this._chestId = 0; this._coins = 0; this._update = false; return true;
        }
        public function parse(data:IMessageDataWrapper):Bool
        {
            if (data.bytesAvailable != 9) { return false; }
            this._chestId = data.readInteger();
            this._coins = data.readInteger();
            this._update = data.readBoolean();
            return true;
        }
        public var chestId(get,never):Int;
public function  get_chestId():Int { return this._chestId; }
        public var coins(get,never):Int;
public function  get_coins():Int { return this._coins; }
        public var isUpdate(get,never):Bool;
public function  get_isUpdate():Bool { return this._update; }

	public function new() {}
    }

