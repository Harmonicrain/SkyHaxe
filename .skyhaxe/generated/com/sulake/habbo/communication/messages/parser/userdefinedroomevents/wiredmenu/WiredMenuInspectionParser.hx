package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     final class WiredMenuInspectionParser implements IMessageParser
    {
        public var type:Int = 0;
        public var objectId:Int = 0;
        public var values:Array<ASAny>;
        public var wiredIds:Array<ASAny>;
        public function flush():Bool
        {
            type = -1;
            objectId = 0;
            values = [];
            wiredIds = [];
            return true;
        }
        public function parse(data:IMessageDataWrapper):Bool
        {
var i = 0;            if (data.bytesAvailable < 8) { return false; }
            type = data.readInteger();
            if (type != 0 && type != 1 && type != -10) { return false; }
            objectId = type == -10 ? 0 : data.readInteger();
            var count= data.readInteger();
            if (count < 0 || count > 4096) { return false; }
            values = [];
            for (_tmp_ in 0...count)
            {
i= _tmp_;
                values.push({id:data.readString(), value:data.readInteger()});
            }
            wiredIds = [];
            if (type == 0)
            {
                count = data.readInteger();
                if (count < 0 || count > 4096) { return false; }
                for (_tmp_ in 0...count) { i= _tmp_;
wiredIds.push(data.readInteger()); }
            }
            return data.bytesAvailable == 0;
        }

	public function new() {}
    }

