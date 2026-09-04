package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
     final class WiredMenuUserVariablesPageParser implements IMessageParser
    {
        public var variableId:String; public var total:Int = 0; public var page:Int = 0;
        public var amount:Int = 0; public var entries:Array<ASAny>; public var userFilter:Int = 0;
        public var sortFilter:Int = 0;
        public function flush():Bool { entries=[]; return true; }
        public function parse(data:IMessageDataWrapper):Bool
        {
            variableId=data.readString(); total=data.readInteger(); page=data.readInteger();
            amount=data.readInteger(); var count=data.readInteger();
            if(count<0||count>500){return false;} entries=[];
            for(i in 0...count){
                entries.push({type:data.readInteger(),id:data.readInteger(),
                    name:data.readString(),value:data.readInteger(),
                    created:data.readLong(),createdText:data.readString(),
                    updated:data.readLong(),updatedText:data.readString()});
            }
            userFilter=data.readInteger(); sortFilter=data.readInteger();
            return data.bytesAvailable==0;
        }

	public function new() {}
    }

