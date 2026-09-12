package com.sulake.habbo.room.object.data
;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.object.IRoomObjectModelController;
    import com.sulake.room.object.IRoomObjectModel;

     class CrackableStuffData extends StuffDataBase implements IStuffData 
    {
        public static final FORMAT_KEY:Int = StuffDataFormatKeyEnum.CRACKABLE_TYPE_KEY;//7
        static inline final FURNITURE_CRACKABLE_STATE= "furniture_crackable_state";
        static inline final FURNITURE_CRACKABLE_HITS= "furniture_crackable_hits";
        static inline final FURNITURE_CRACKABLE_TARGET= "furniture_crackable_target";

        var _state:String = "";
        var _hits:Int = 0;
        var _target:Int = 0;


        override public function initializeFromIncomingMessage(k:IMessageDataWrapper)
        {
            this._state = k.readString();
            this._hits = k.readInteger();
            this._target = k.readInteger();
            super.initializeFromIncomingMessage(k);
        }

        override public function writeRoomObjectModel(k:IRoomObjectModelController)
        {
            super.writeRoomObjectModel(k);
            k.setNumber(RoomObjectVariableEnum.FURNITURE_DATA_FORMAT, FORMAT_KEY);
            k.setString(FURNITURE_CRACKABLE_STATE, this._state);
            k.setNumber(FURNITURE_CRACKABLE_HITS, this._hits);
            k.setNumber(FURNITURE_CRACKABLE_TARGET, this._target);
        }

        override public function initializeFromRoomObjectModel(k:IRoomObjectModel)
        {
            super.initializeFromRoomObjectModel(k);
            this._state = k.getString(FURNITURE_CRACKABLE_STATE);
            this._hits = Std.int(k.getNumber(FURNITURE_CRACKABLE_HITS));
            this._target = Std.int(k.getNumber(FURNITURE_CRACKABLE_TARGET));
        }

        override public function getLegacyString():String
        {
            return this._state;
        }

        public function setString(k:String)
        {
            this._state = k;
        }

        public var hits(get,never):Int;
public function  get_hits():Int
        {
            return this._hits;
        }

        public var target(get,never):Int;
public function  get_target():Int
        {
            return this._target;
        }

        override public function compare(k:IStuffData):Bool
        {
            return true;
        }

	public function new() { super(); }
    }

