package com.sulake.habbo.room.object.data
;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.room.object.IRoomObjectModelController;
    import adobe.serialization.json.JSONDecoder;

     class StuffDataBase implements IStuffData 
    {
        var _flags:Int = 0;
        var _uniqueSerialNumber:Int = 0;
        var _uniqueSeriesSize:Int = 0;


        public var flags(never,set):Int;
function  set_flags(k:Int):Int        {
            return this._flags = k;
        }

        public function initializeFromIncomingMessage(k:IMessageDataWrapper)
        {
            if ((this._flags & StuffDataFlagsEnum.UNIQUE_SERIAL_NUMBER) > 0)
            {
                this._uniqueSerialNumber = k.readInteger();
                this._uniqueSeriesSize = k.readInteger();
            }
        }

        public function initializeFromRoomObjectModel(k:IRoomObjectModel)
        {
            this._uniqueSerialNumber = Std.int(k.getNumber(RoomObjectVariableEnum.FURNITURE_UNIQUE_SERIAL_NUMBER));
            this._uniqueSeriesSize = Std.int(k.getNumber(RoomObjectVariableEnum.FURNITURE_UNIQUE_EDITION_SIZE));
        }

        public function writeRoomObjectModel(k:IRoomObjectModelController)
        {
            k.setNumber(RoomObjectVariableEnum.FURNITURE_UNIQUE_SERIAL_NUMBER, this._uniqueSerialNumber);
            k.setNumber(RoomObjectVariableEnum.FURNITURE_UNIQUE_EDITION_SIZE, this._uniqueSeriesSize);
        }

        
        public var uniqueSerialNumber(get,set):Int;
function  get_uniqueSerialNumber():Int
        {
            return this._uniqueSerialNumber;
        }

        
        public var uniqueSeriesSize(get,set):Int;
function  get_uniqueSeriesSize():Int
        {
            return this._uniqueSeriesSize;
        }
function  set_uniqueSerialNumber(k:Int):Int        {
            return this._uniqueSerialNumber = k;
        }
function  set_uniqueSeriesSize(k:Int):Int        {
            return this._uniqueSeriesSize = k;
        }

        public function getLegacyString():String
        {
            return "";
        }

        public function compare(k:IStuffData):Bool
        {
            return false;
        }

        public var rarityLevel(get,never):Int;
function  get_rarityLevel():Int
        {
            return -1;
        }

        public var contentsCount(get,never):Int;
function  get_contentsCount():Int
        {
            return 0;
        }

        public var chestName(get,never):String;
function  get_chestName():String
        {
            return "";
        }

        public var state(get,never):Int;
function  get_state():Int
        {
            var k= ASCompat.toNumber(this.getLegacyString());
            return Math.isNaN(k) ? -1 : Std.int(k);
        }

        public function getJSONValue(key:String):String
        {
            var value:String;
            try
            {
                value = new JSONDecoder(this.getLegacyString(), true).getValue()[key];
                return value;
            }
            catch(error:ASError)
            {
                return "";
            }
            return "";
        }

	public function new() {}
    }

