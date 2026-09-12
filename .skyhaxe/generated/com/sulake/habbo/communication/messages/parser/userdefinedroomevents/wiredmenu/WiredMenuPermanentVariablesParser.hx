package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
     final class WiredMenuPermanentVariablesParser implements IMessageParser
    {
        public var type:Int = 0; public var id:Int = 0; public var name:String;
        public var figure:String; public var ownerId:Int = 0; public var ownerName:String;
        public var ownerFigure:String; public var entries:Array<ASAny>;
        public function flush():Bool { entries=[]; return true; }
        public function parse(data:IMessageDataWrapper):Bool
        {
var i = 0;            type=data.readInteger(); id=data.readInteger(); name=data.readString();
            figure=data.readString();
            if(type!=1){ownerId=data.readInteger();ownerName=data.readString();
                ownerFigure=data.readString();}
            var count=data.readInteger();
            if(count<0||count>4096){return false;} entries=[];
            for(_tmp_ in 0...count){
i=_tmp_;
                entries.push({variableId:data.readString(),value:data.readInteger(),
                    created:data.readLong(),createdText:data.readString(),
                    updated:data.readLong(),updatedText:data.readString()});
            }
            return data.bytesAvailable==0;
        }

	public function new() {}
    }

