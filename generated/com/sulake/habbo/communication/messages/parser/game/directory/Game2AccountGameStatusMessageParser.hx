package com.sulake.habbo.communication.messages.parser.game.directory
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class Game2AccountGameStatusMessageParser implements IMessageParser
    {
        var _gameTypeId:Int = 0;
        var _freeGamesLeft:Int = 0;
        var _gamesPlayedTotal:Int = 0;


        public var gameTypeId(get,never):Int;
function  get_gameTypeId():Int
        {
            return this._gameTypeId;
        }

        public var freeGamesLeft(get,never):Int;
function  get_freeGamesLeft():Int
        {
            return this._freeGamesLeft;
        }

        public var gamesPlayedTotal(get,never):Int;
function  get_gamesPlayedTotal():Int
        {
            return this._gamesPlayedTotal;
        }

        public var hasUnlimitedGames(get,never):Bool;
function  get_hasUnlimitedGames():Bool
        {
            return this._freeGamesLeft == -1;
        }

        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._gameTypeId = k.readInteger();
            this._freeGamesLeft = k.readInteger();
            this._gamesPlayedTotal = k.readInteger();
            return true;
        }

	public function new() {}
    }

