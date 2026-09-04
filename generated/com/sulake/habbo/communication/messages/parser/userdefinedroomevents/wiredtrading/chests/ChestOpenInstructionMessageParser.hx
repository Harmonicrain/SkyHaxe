package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class ChestOpenInstructionMessageParser implements IMessageParser
    {
        var _chestId:Int = 0;
        public function flush():Bool { this._chestId = 0; return true; }
        public function parse(data:IMessageDataWrapper):Bool
        {
            if (data.bytesAvailable != 4) { return false; }
            this._chestId = data.readInteger();
            return true;
        }
        public var chestId(get,never):Int;
function  get_chestId():Int { return this._chestId; }

	public function new() {}
    }

