package com.sulake.habbo.communication.messages.parser.game.score
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class Game2LeaderboardParser implements IMessageParser
    {
        var _gameTypeId:Int = 0;
        var _leaderBoard:Array<ASAny>;
        var _totalListSize:Int = 0;


        public function flush():Bool
        {
            this._gameTypeId = -1;
            this._leaderBoard = null;
            this._totalListSize = -1;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._leaderBoard = [];
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._leaderBoard.push(new LeaderboardEntry(k));
                _local_3++;
            }
            this._totalListSize = k.readInteger();
            this._gameTypeId = k.readInteger();
            return true;
        }

        public var gameTypeId(get,never):Int;
public function  get_gameTypeId():Int
        {
            return this._gameTypeId;
        }

        public var leaderboard(get,never):Array<ASAny>;
public function  get_leaderboard():Array<ASAny>
        {
            return this._leaderBoard;
        }

        public var _Str_26158(get,never):Int;
public function  get__Str_26158():Int
        {
            return this._totalListSize;
        }

	public function new() {}
    }

