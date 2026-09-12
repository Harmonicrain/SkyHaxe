package com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     final class WiredMenuRoomStatsParser implements IMessageParser
    {
        public var executionCost:Float = Math.NaN;
        public var executionCap:Float = Math.NaN;
        public var heavy:Bool = false;
        public var floorCount:Int = 0;
        public var floorCap:Int = 0;
        public var wallCount:Int = 0;
        public var wallCap:Int = 0;
        public var permanentFurniCount:Int = 0;
        public var permanentFurniCap:Int = 0;
        public var permanentUserCount:Int = 0;
        public var permanentUserCap:Int = 0;
        public var permanentGlobalCount:Int = 0;
        public var permanentGlobalCap:Int = 0;
        public function flush():Bool { return true; }
        public function parse(data:IMessageDataWrapper):Bool
        {
            if (data.bytesAvailable != 57) { return false; }
            executionCost = data.readDouble(); executionCap = data.readDouble();
            heavy = data.readBoolean();
            floorCount = data.readInteger(); floorCap = data.readInteger();
            wallCount = data.readInteger(); wallCap = data.readInteger();
            permanentFurniCount = data.readInteger();
            permanentFurniCap = data.readInteger();
            permanentUserCount = data.readInteger();
            permanentUserCap = data.readInteger();
            permanentGlobalCount = data.readInteger();
            permanentGlobalCap = data.readInteger();
            return true;
        }

	public function new() {}
    }

