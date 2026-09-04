package com.sulake.habbo.room.object.data
;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.room.object.IRoomObjectModelController;

     class IntArrayStuffData extends StuffDataBase implements IStuffData 
    {
        public static final FORMAT_KEY:Int = StuffDataFormatKeyEnum.INT_ARRAY_TYPE_KEY;
        static inline final STATE_DEFAULT_INDEX= 0;

        var _data:Array<ASAny>;

        public function new()
        {
            this._data = [];
            super();
        }

        override public function initializeFromIncomingMessage(k:IMessageDataWrapper)
        {
            var readout:Int;
            this._data = new Array<ASAny>();
            var amount= k.readInteger();
            var iterator = 0;
            while (iterator < amount)
            {
                readout = k.readInteger();
                this._data.push(readout);
                iterator++;
            }
            super.initializeFromIncomingMessage(k);
        }

        override public function initializeFromRoomObjectModel(k:IRoomObjectModel)
        {
            super.initializeFromRoomObjectModel(k);
            this._data = k.getNumberArray(RoomObjectVariableEnum.FURNITURE_DATA);
        }

        override public function writeRoomObjectModel(k:IRoomObjectModelController)
        {
            super.writeRoomObjectModel(k);
            k.setNumber(RoomObjectVariableEnum.FURNITURE_DATA_FORMAT, FORMAT_KEY);
            k.setNumberArray(RoomObjectVariableEnum.FURNITURE_DATA, this._data);
        }

        override public function getLegacyString():String
        {
            if (this._data == null)
            {
                return "";
            }
            return this._data[STATE_DEFAULT_INDEX];
        }

        public function getValue(k:Int):Int
        {
            if (((this._data != null) && (k < this._data.length)))
            {
                return ASCompat.toInt(this._data[k]);
            }
            return -1;
        }

        public function _Str_13438(k:Array<ASAny>)
        {
            this._data = k;
        }

        override public function compare(k:IStuffData):Bool
        {
            var _local_2= Std.downcast(k , IntArrayStuffData);
            if (_local_2 == null)
            {
                return false;
            }
            var _local_3 = 0;
            while (_local_3 < this._data.length)
            {
                if (_local_3 == STATE_DEFAULT_INDEX)
                {
                }
                else
                {
                    if (this._data[_local_3] != _local_2.getValue(_local_3))
                    {
                        return false;
                    }
                }
                _local_3++;
            }
            return true;
        }
    }

