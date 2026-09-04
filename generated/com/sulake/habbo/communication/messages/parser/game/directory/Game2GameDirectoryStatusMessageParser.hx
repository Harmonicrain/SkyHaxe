package com.sulake.habbo.communication.messages.parser.game.directory
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class Game2GameDirectoryStatusMessageParser implements IMessageParser
    {
        public static inline final STATUS_OK= 0;
        public static inline final STATUS_FAILED_REASON_UNKNOWN= 1;
        public static inline final STATUS_FAILED_REASON_GAME_DIRECTORY_IS_NOT_AVAILABLE= 2;
        public static inline final STATUS_FAILED_REASON_HOTEL_IS_CLOSED= 3;

        var _status:Int = 0;
        var _blockLength:Int = 0;
        var _gamesPlayed:Int = 0;
        var _freeGamesLeft:Int = 0;


        public var status(get,never):Int;
function  get_status():Int
        {
            return this._status;
        }

        public var blockLength(get,never):Int;
function  get_blockLength():Int
        {
            return this._blockLength;
        }

        public var gamesPlayed(get,never):Int;
function  get_gamesPlayed():Int
        {
            return this._gamesPlayed;
        }

        public var freeGamesLeft(get,never):Int;
function  get_freeGamesLeft():Int
        {
            return this._freeGamesLeft;
        }

        public var hasUnlimitedGames(get,never):Bool;
function  get_hasUnlimitedGames():Bool
        {
            return this._freeGamesLeft == -1;
        }

        public function flush():Bool
        {
            return false;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._status = k.readInteger();
            this._blockLength = k.readInteger();
            this._gamesPlayed = k.readInteger();
            this._freeGamesLeft = k.readInteger();
            return true;
        }

	public function new() {}
    }

