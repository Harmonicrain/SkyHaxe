package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
     final class WiredMenuMutationResultParser implements IMessageParser
    {
        var _success:Bool = false;
        public function flush():Bool { _success = false; return true; }
        public function parse(data:IMessageDataWrapper):Bool
        {
            if (data.bytesAvailable != 1) { return false; }
            _success = data.readBoolean(); return true;
        }
        public var success(get,never):Bool;
function  get_success():Bool { return _success; }

	public function new() {}
    }

