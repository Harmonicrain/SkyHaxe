package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.contracts
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class ChestContractUpdateResultMessageParser implements IMessageParser
    {
        var _contractId:Int = 0;
        var _success:Bool = false;
        var _failCode:String;
        public function flush():Bool
        {
            this._contractId = 0;
            this._success = false;
            this._failCode = null;
            return true;
        }
        public function parse(data:IMessageDataWrapper):Bool
        {
            if (data.bytesAvailable < 7) return false;
            this._contractId = data.readInteger();
            this._success = data.readBoolean();
            this._failCode = data.readString();
            return data.bytesAvailable == 0;
        }
        public var contractId(get,never):Int;
public function  get_contractId():Int { return this._contractId; }
        public var isSuccess(get,never):Bool;
public function  get_isSuccess():Bool { return this._success; }
        public var failCode(get,never):String;
public function  get_failCode():String { return this._failCode; }

	public function new() {}
    }

