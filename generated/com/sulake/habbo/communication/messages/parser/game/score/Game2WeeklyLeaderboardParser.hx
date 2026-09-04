package com.sulake.habbo.communication.messages.parser.game.score
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class Game2WeeklyLeaderboardParser extends Game2LeaderboardParser
    {
        var _year:Int = 0;
        var _week:Int = 0;
        var _maxOffset:Int = 0;
        var _currentOffset:Int = 0;
        var _minutesUntilReset:Int = 0;


        public var year(get,never):Int;
function  get_year():Int
        {
            return this._year;
        }

        public var week(get,never):Int;
function  get_week():Int
        {
            return this._week;
        }

        public var maxOffset(get,never):Int;
function  get_maxOffset():Int
        {
            return this._maxOffset;
        }

        public var currentOffset(get,never):Int;
function  get_currentOffset():Int
        {
            return this._currentOffset;
        }

        public var minutesUntilReset(get,never):Int;
function  get_minutesUntilReset():Int
        {
            return this._minutesUntilReset;
        }

        override public function flush():Bool
        {
            this._year = -1;
            this._week = -1;
            this._maxOffset = -1;
            this._currentOffset = -1;
            this._minutesUntilReset = -1;
            return super.flush();
        }

        override public function parse(k:IMessageDataWrapper):Bool
        {
            this._year = k.readInteger();
            this._week = k.readInteger();
            this._maxOffset = k.readInteger();
            this._currentOffset = k.readInteger();
            this._minutesUntilReset = k.readInteger();
            return super.parse(k);
        }

	public function new() { super(); }
    }

