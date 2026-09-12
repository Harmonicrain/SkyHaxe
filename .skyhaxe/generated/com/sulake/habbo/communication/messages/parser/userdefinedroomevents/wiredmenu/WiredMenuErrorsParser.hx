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
var i = 0;            if (data.bytesAvailable < 4) { return false; }
            var count= data.readInteger();
            if (count < 0 || count > 500) { return false; }
            _errors = [];
            for (_tmp_ in 0...count)
            {
i= _tmp_;
                if (data.bytesAvailable < 16) { return false; }
                _errors.push({id:data.readInteger(), name:data.readString(),
                    category:data.readString(), count:data.readInteger(),
                    elapsed:data.readLong()});
            }
            return data.bytesAvailable == 0;
        }
        public var errors(get,never):Array<ASAny>;
public function  get_errors():Array<ASAny> { return _errors; }

	public function new() {}
    }

