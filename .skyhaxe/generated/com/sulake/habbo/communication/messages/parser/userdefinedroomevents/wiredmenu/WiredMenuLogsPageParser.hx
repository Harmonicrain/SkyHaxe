package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
     final class WiredMenuLogsPageParser implements IMessageParser
    {
        public var total:Int = 0; public var page:Int = 0; public var amount:Int = 0;
        public var entries:Array<ASAny>;
        public var levelFilter:Int = -1;
        public var sourceFilter:Int = -1;
        public var query:String = "";
        public function flush():Bool
        {
            entries = [];
            levelFilter = -1;
            sourceFilter = -1;
            query = "";
            return true;
        }
        public function parse(data:IMessageDataWrapper):Bool
        {
var i = 0;            if (data.bytesAvailable < 16) { return false; }
            total=data.readInteger(); page=data.readInteger(); amount=data.readInteger();
            var count=data.readInteger();
            if(count<0||count>500){return false;} entries=[];
            for(_tmp_ in 0...count){
i=_tmp_;
                entries.push({id:data.readLong(),level:data.readByte(),
                    source:data.readByte(),message:data.readString(),
                    timestamp:data.readLong(),timestampText:data.readString()});
            }
            if(data.bytesAvailable<3){return false;}
            if(data.readBoolean()){levelFilter=data.readByte();}
            if(data.readBoolean()){sourceFilter=data.readByte();}
            if(data.readBoolean()){query=data.readString();}
            return data.bytesAvailable==0;
        }

	public function new() {}
    }

