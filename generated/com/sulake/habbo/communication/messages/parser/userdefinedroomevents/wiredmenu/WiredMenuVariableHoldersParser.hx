package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.VariableInfoAndHolders;
     final class WiredMenuVariableHoldersParser implements IMessageParser
    {
        var _data:VariableInfoAndHolders;
        public function flush():Bool { _data = null; return true; }
        public function parse(input:IMessageDataWrapper):Bool
        {
            if (input.bytesAvailable < 4) { return false; }
            input.readInteger();
            _data = new VariableInfoAndHolders(input);
            return input.bytesAvailable == 0;
        }
        public var data(get,never):VariableInfoAndHolders;
function  get_data():VariableInfoAndHolders { return _data; }

	public function new() {}
    }

