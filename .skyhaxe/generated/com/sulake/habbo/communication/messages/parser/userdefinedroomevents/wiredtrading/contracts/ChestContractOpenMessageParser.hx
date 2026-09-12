package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.contracts
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class ChestContractOpenMessageParser implements IMessageParser
    {
        var _contractId:Int = 0;
        public function flush():Bool { this._contractId = 0; return true; }
        public function parse(data:IMessageDataWrapper):Bool
        {
            if (data.bytesAvailable != 4) return false;
            this._contractId = data.readInteger();
            return true;
        }
        public var contractId(get,never):Int;
public function  get_contractId():Int { return this._contractId; }

	public function new() {}
    }

