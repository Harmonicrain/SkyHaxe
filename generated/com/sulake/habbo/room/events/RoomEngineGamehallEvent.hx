package com.sulake.habbo.room.events
;
    import com.sulake.habbo.room.object.RoomObjectCategoryEnum;

     class RoomEngineGamehallEvent extends RoomEngineObjectEvent
    {
        public static inline final OPEN= "REGHE_GAMEHALL_OPEN";
        public static inline final UPDATE= "REGHE_GAMEHALL_UPDATE";
        public static inline final CLOSE= "REGHE_GAMEHALL_CLOSE";

        var _gameType:String;
        var _localSeat:Int = 0;
        var _seatCount:Int = 0;
        var _verb:String;
        var _args:Array<ASAny>;
        var _reason:String;

        public function new(type:String, roomId:Int, stationId:Int, gameType:String="", localSeat:Int=0, seatCount:Int=0, verb:String="", args:Array<ASAny>=null, reason:String="")
        {
            super(type, roomId, stationId, RoomObjectCategoryEnum.OBJECT_CATEGORY_UNKNOWN);
            this._gameType = gameType;
            this._localSeat = localSeat;
            this._seatCount = seatCount;
            this._verb = verb;
            this._args = (args == null) ? [] : args;
            this._reason = reason;
        }

        public var stationId(get,never):Int;
function  get_stationId():Int
        {
            return objectId;
        }

        public var gameType(get,never):String;
function  get_gameType():String
        {
            return this._gameType;
        }

        public var localSeat(get,never):Int;
function  get_localSeat():Int
        {
            return this._localSeat;
        }

        public var seatCount(get,never):Int;
function  get_seatCount():Int
        {
            return this._seatCount;
        }

        public var verb(get,never):String;
function  get_verb():String
        {
            return this._verb;
        }

        public var args(get,never):Array<ASAny>;
function  get_args():Array<ASAny>
        {
            return this._args;
        }

        public var reason(get,never):String;
function  get_reason():String
        {
            return this._reason;
        }
    }

