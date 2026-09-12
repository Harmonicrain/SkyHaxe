package com.sulake.habbo.room.object.data
;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.room.object.IRoomObjectModelController;

     class LegacyStuffData extends StuffDataBase implements IStuffData 
    {
        public static final FORMAT_KEY:Int = StuffDataFormatKeyEnum.LEGACY_TYPE_KEY;//0

        var _data:String = "";

        override public function initializeFromIncomingMessage(k:IMessageDataWrapper)
        {
            this._data = k.readString();
            super.initializeFromIncomingMessage(k);
        }

        override public function initializeFromRoomObjectModel(k:IRoomObjectModel)
        {
            super.initializeFromRoomObjectModel(k);
            this._data = k.getString(RoomObjectVariableEnum.FURNITURE_DATA);
        }

        override public function writeRoomObjectModel(k:IRoomObjectModelController)
        {
            super.writeRoomObjectModel(k);
            k.setNumber(RoomObjectVariableEnum.FURNITURE_DATA_FORMAT, FORMAT_KEY);
            k.setString(RoomObjectVariableEnum.FURNITURE_DATA, this._data);
        }

        override public function getLegacyString():String
        {
            return this._data;
        }

        public function setString(k:String)
        {
            this._data = k;
        }

        override public function compare(k:IStuffData):Bool
        {
            return this._data == k.getLegacyString();
        }

	public function new() { super(); }
    }

