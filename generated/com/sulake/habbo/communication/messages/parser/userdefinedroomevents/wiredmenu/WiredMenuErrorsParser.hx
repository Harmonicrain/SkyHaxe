package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     final class WiredMenuErrorsParser implements IMessageParser
    {
        var _errors:Array<ASAny>;
        public function flush():Bool { _errors = []; return true; }
        public function parse(data:IMessageDataWrapper):Bool
        {
            if (data.bytesAvailable < 4) { return false; }
            var count= data.readInteger();
            if (count < 0 || count > 500) { return false; }
            _errors = [];
            for (i in 0...count)
            {
                if (data.bytesAvailable < 16) { return false; }
                _errors.push({id:data.readInteger(), name:data.readString(),
                    category:data.readString(), count:data.readInteger(),
                    elapsed:data.readLong()});
            }
            return data.bytesAvailable == 0;
        }
        public var errors(get,never):Array<ASAny>;
function  get_errors():Array<ASAny> { return _errors; }

	public function new() {}
    }

