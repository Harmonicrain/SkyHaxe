package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     final class WiredMenuRoomSettingsParser implements IMessageParser
    {
        var _modify:Int = 0;
        var _read:Int = 0;
        var _timezone:String;
        public function flush():Bool { _modify = 0; _read = 0; _timezone = null; return true; }
        public function parse(data:IMessageDataWrapper):Bool
        {
            if (data.bytesAvailable < 10) { return false; }
            _modify = data.readInteger(); _read = data.readInteger();
            _timezone = data.readString(); return data.bytesAvailable == 0;
        }
        public var modifyMask(get,never):Int;
function  get_modifyMask():Int { return _modify; }
        public var readMask(get,never):Int;
function  get_readMask():Int { return _read; }
        public var timezone(get,never):String;
function  get_timezone():String { return _timezone; }

	public function new() {}
    }

