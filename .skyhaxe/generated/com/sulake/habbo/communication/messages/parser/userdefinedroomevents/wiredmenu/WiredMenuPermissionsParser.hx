package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     final class WiredMenuPermissionsParser implements IMessageParser
    {
        var _write:Bool = false;
        var _read:Bool = false;
        public function flush():Bool { _write = false; _read = false; return true; }
        public function parse(data:IMessageDataWrapper):Bool
        {
            if (data.bytesAvailable != 2) { return false; }
            _write = data.readBoolean(); _read = data.readBoolean(); return true;
        }
        public var writePermission(get,never):Bool;
public function  get_writePermission():Bool { return _write; }
        public var readPermission(get,never):Bool;
public function  get_readPermission():Bool { return _read; }

	public function new() {}
    }

