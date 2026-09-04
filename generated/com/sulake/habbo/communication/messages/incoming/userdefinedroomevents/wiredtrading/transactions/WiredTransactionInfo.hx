package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.transactions
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

    /** One exact July transaction-log summary record. */
     class WiredTransactionInfo
    {
        public static inline final TYPE_MANUAL= 0;
        public static inline final TYPE_WIRED= 1;
        public static inline final TYPE_CONTRACT_PAYMENT= 2;
        public static inline final TYPE_CONTRACT_REWARD= 3;
        public static inline final TYPE_CONTRACT_TRADE= 4;

        var _transactionId:Float = Math.NaN;
        var _roomId:Int = 0;
        var _transactionType:Int = 0;
        var _definitionInfo:String;
        var _userId:Int = 0;
        var _username:String;
        var _timestamp:Float = Math.NaN;
        var _readableTimestamp:String;
        var _chestCount:Int = 0;
        var _withdrawFurniCount:Int = 0;
        var _depositFurniCount:Int = 0;
        var _withdrawCoinsCount:Int = 0;
        var _depositCoinsCount:Int = 0;

        public function new(data:IMessageDataWrapper)
        {
            this._transactionId = data.readLong();
            this._roomId = data.readInteger();
            this._transactionType = data.readInteger();
            this._definitionInfo = data.readString();
            this._userId = data.readInteger();
            this._username = data.readString();
            this._timestamp = data.readLong();
            this._readableTimestamp = data.readString();
            this._chestCount = data.readInteger();
            this._withdrawFurniCount = data.readInteger();
            this._depositFurniCount = data.readInteger();
            this._withdrawCoinsCount = data.readInteger();
            this._depositCoinsCount = data.readInteger();
        }

        public var transactionId(get,never):Float;
function  get_transactionId():Float { return this._transactionId; }
        public var roomId(get,never):Int;
function  get_roomId():Int { return this._roomId; }
        public var transactionType(get,never):Int;
function  get_transactionType():Int { return this._transactionType; }
        public var transactionDefinitionInfo(get,never):String;
function  get_transactionDefinitionInfo():String { return this._definitionInfo; }
        public var userId(get,never):Int;
function  get_userId():Int { return this._userId; }
        public var username(get,never):String;
function  get_username():String { return this._username; }
        public var timestamp(get,never):Float;
function  get_timestamp():Float { return this._timestamp; }
        public var readableTimestamp(get,never):String;
function  get_readableTimestamp():String { return this._readableTimestamp; }
        public var chestCount(get,never):Int;
function  get_chestCount():Int { return this._chestCount; }
        public var withdrawFurniCount(get,never):Int;
function  get_withdrawFurniCount():Int { return this._withdrawFurniCount; }
        public var depositFurniCount(get,never):Int;
function  get_depositFurniCount():Int { return this._depositFurniCount; }
        public var withdrawCoinsCount(get,never):Int;
function  get_withdrawCoinsCount():Int { return this._withdrawCoinsCount; }
        public var depositCoinsCount(get,never):Int;
function  get_depositCoinsCount():Int { return this._depositCoinsCount; }
    }

