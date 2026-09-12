package com.sulake.habbo.room.object.data
;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.room.object.IRoomObjectModelController;
    import com.sulake.habbo.room.object.*;
    import com.sulake.habbo.room.*;

     class MapStuffData extends StuffDataBase implements IStuffData 
    {
        public static final FORMAT_KEY:Int = StuffDataFormatKeyEnum.MAP_TYPE_KEY;//1
        static inline final STATE= "state";
        static inline final RARITY= "rarity";

        var _data:Map;

        public function new(k:Map=null)
        {
            super();
            if (k != null)
            {
                this._data = k;
            }
        }

        override public function initializeFromIncomingMessage(k:IMessageDataWrapper)
        {
            var key:String = null;
            var value:String = null;
            this._data = new Map();
            var amount= k.readInteger();
            var iterator = 0;
            while (iterator < amount)
            {
                key = k.readString();
                value = k.readString();
                this._data.add(key, value);
                iterator++;
            }
            super.initializeFromIncomingMessage(k);
        }

        override public function initializeFromRoomObjectModel(k:IRoomObjectModel)
        {
            super.initializeFromRoomObjectModel(k);
            this._data = k.getStringToStringMap(RoomObjectVariableEnum.FURNITURE_DATA);
        }

        override public function writeRoomObjectModel(k:IRoomObjectModelController)
        {
            super.writeRoomObjectModel(k);
            k.setNumber(RoomObjectVariableEnum.FURNITURE_DATA_FORMAT, FORMAT_KEY);
            k.setStringToStringMap(RoomObjectVariableEnum.FURNITURE_DATA, this._data);
        }

        override public function getLegacyString():String
        {
            if (((this._data != null) && (!(this._data.getValue(STATE) == null))))
            {
                return this._data.getValue(STATE);
            }
            return "";
        }

        public function getValue(k:String):String
        {
            return this._data.getValue(k);
        }

        override public function compare(k:IStuffData):Bool
        {
            return false;
        }

        override public function  get_rarityLevel():Int
        {
            var k:String = this._data.getValue(RARITY);
            if (ASCompat.stringAsBool(k))
            {
                return ASCompat.toInt(k);
            }
            return -1;
        }

        override public function  get_contentsCount():Int
        {
            if (this._data == null)
            {
                return 0;
            }
            var value:String = this._data.getValue("contents_count");
            return value == null ? 0 : ASCompat.toInt(value);
        }

        override public function  get_chestName():String
        {
            if (this._data == null)
            {
                return "";
            }
            var value:String = this._data.getValue("chest_name");
            return value == null ? "" : value;
        }
    }

