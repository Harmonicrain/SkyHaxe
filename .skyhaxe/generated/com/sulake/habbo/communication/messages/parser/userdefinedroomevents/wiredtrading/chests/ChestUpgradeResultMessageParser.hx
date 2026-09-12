package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.chests
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class ChestUpgradeResultMessageParser implements IMessageParser
    {
        public static inline final SUCCESS= 0;
        var _chestId:Int = 0;
        var _resultCode:Int = 0;
        public function flush():Bool { this._chestId = 0; this._resultCode = 0; return true; }
        public function parse(data:IMessageDataWrapper):Bool
        {
            if (data.bytesAvailable != 8) { return false; }
            this._chestId = data.readInteger();
            this._resultCode = data.readInteger();
            return true;
        }
        public var chestId(get,never):Int;
public function  get_chestId():Int { return this._chestId; }
        public var resultCode(get,never):Int;
public function  get_resultCode():Int { return this._resultCode; }

	public function new() {}
    }

