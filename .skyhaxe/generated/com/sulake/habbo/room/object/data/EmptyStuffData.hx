package com.sulake.habbo.room.object.data
;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.room.object.IRoomObjectModelController;

     class EmptyStuffData extends StuffDataBase implements IStuffData 
    {
        override public function initializeFromIncomingMessage(k:IMessageDataWrapper)
        {
            super.initializeFromIncomingMessage(k);
        }

        override public function initializeFromRoomObjectModel(k:IRoomObjectModel)
        {
            super.initializeFromRoomObjectModel(k);
        }

        override public function writeRoomObjectModel(k:IRoomObjectModelController)
        {
            super.writeRoomObjectModel(k);
        }

        override public function getLegacyString():String
        {
            return "";
        }

        override public function compare(k:IStuffData):Bool
        {
            return super.compare(k);
        }

	public function new() { super(); }
    }

