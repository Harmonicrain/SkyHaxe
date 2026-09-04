package com.sulake.habbo.room.object.data
;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.core.utils.Map;
    import com.sulake.room.object.IRoomObjectModelController;
    import com.sulake.room.object.IRoomObjectModel;

     class VoteResultStuffData extends StuffDataBase implements IStuffData 
    {
        public static final FORMAT_KEY:Int = StuffDataFormatKeyEnum.VOTE_RESULT_TYPE_KEY;
        static inline final S= "s";
        static inline final R= "r";

        var _state:String = "";
        var _result:Int = 0;


        override public function initializeFromIncomingMessage(k:IMessageDataWrapper)
        {
            this._state = k.readString();
            this._result = k.readInteger();
            super.initializeFromIncomingMessage(k);
        }

        override public function writeRoomObjectModel(k:IRoomObjectModelController)
        {
            super.writeRoomObjectModel(k);
            k.setNumber(RoomObjectVariableEnum.FURNITURE_DATA_FORMAT, FORMAT_KEY);
            var data= new Map();
            data.add(S, this._state);
            data.add(R, Std.string(this._result));
            k.setStringToStringMap(RoomObjectVariableEnum.FURNITURE_DATA, data);
        }

        override public function initializeFromRoomObjectModel(k:IRoomObjectModel)
        {
            super.initializeFromRoomObjectModel(k);
            var _local_2= k.getStringToStringMap(RoomObjectVariableEnum.FURNITURE_DATA);
            this._state = _local_2.getValue(S);
            this._result = ASCompat.toInt(_local_2.getValue(R));
        }

        override public function getLegacyString():String
        {
            return this._state;
        }

        public function setString(state:String)
        {
            this._state = state;
        }

        public var result(get,never):Int;
function  get_result():Int
        {
            return this._result;
        }

        override public function compare(k:IStuffData):Bool
        {
            return true;
        }
public function new(){	super();
}
    }

