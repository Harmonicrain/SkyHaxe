package com.sulake.habbo.communication.messages.parser.games
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class OpenGameBoardMessageParser implements IMessageParser
    {
        var _stationId:Int = 0;
        var _gameType:String = "";
        var _localSeat:Int = 0;
        var _seatCount:Int = 0;

        public var stationId(get,never):Int;
public function  get_stationId():Int
        {
            return this._stationId;
        }

        public var gameType(get,never):String;
public function  get_gameType():String
        {
            return this._gameType;
        }

        public var localSeat(get,never):Int;
public function  get_localSeat():Int
        {
            return this._localSeat;
        }

        public var seatCount(get,never):Int;
public function  get_seatCount():Int
        {
            return this._seatCount;
        }

        public function flush():Bool
        {
            this._stationId = 0;
            this._gameType = "";
            this._localSeat = 0;
            this._seatCount = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._stationId = k.readInteger();
            this._gameType = k.readString();
            this._localSeat = k.readInteger();
            this._seatCount = k.readInteger();
            return true;
        }

	public function new() {}
    }

