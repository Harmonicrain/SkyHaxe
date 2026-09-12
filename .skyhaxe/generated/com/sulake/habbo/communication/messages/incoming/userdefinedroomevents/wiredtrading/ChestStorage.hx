package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.communication.messages.parser.room.engine.ObjectDataParser;
    import com.sulake.habbo.room.IStuffData;

    /** One furniture record in the July Wired chest inventory protocol. */
     class ChestStorage
    {
        public static inline final UNLOCKED= 0;
        public static inline final LOCKED= 1;
        public static inline final OFFERED= 2;
        public static inline final RESERVED= 3;

        var _inventoryId:Int = 0;
        var _lockState:Int = 0;
        var _transactionId:Float = Math.NaN;
        var _type:ChestItemType;
        var _groupable:Bool = false;
        var _specialType:Int = 0;
        var _stuffData:IStuffData;
        var _extra:Int = 0;

        public function new(data:IMessageDataWrapper)
        {
            this._inventoryId = data.readInteger();
            this._lockState = data.readInteger();
            this._transactionId = data.readLong();
            this._type = ChestItemType.readFromMessage(data);
            this._groupable = data.readBoolean();
            this._specialType = data.readInteger();
            this._stuffData = ObjectDataParser.parseStuffData(data);
            if (!this._type.isWallItem)
            {
                this._extra = data.readInteger();
            }
        }

        public var inventoryId(get,never):Int;
public function  get_inventoryId():Int { return this._inventoryId; }
        public var lockState(get,never):Int;
public function  get_lockState():Int { return this._lockState; }
        public var transactionId(get,never):Float;
public function  get_transactionId():Float { return this._transactionId; }
        public var type(get,never):ChestItemType;
public function  get_type():ChestItemType { return this._type; }
        public var groupable(get,never):Bool;
public function  get_groupable():Bool { return this._groupable; }
        public var specialType(get,never):Int;
public function  get_specialType():Int { return this._specialType; }
        public var stuffData(get,never):IStuffData;
public function  get_stuffData():IStuffData { return this._stuffData; }
        public var extra(get,never):Int;
public function  get_extra():Int { return this._extra; }
    }

