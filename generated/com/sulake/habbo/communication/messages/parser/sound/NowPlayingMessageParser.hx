package com.sulake.habbo.communication.messages.parser.sound
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class NowPlayingMessageParser implements IMessageParser
    {
        var _currentSongId:Int = 0;
        var _currentPosition:Int = 0;
        var _nextSongId:Int = 0;
        var _nextPosition:Int = 0;
        var _syncCount:Int = 0;


        public var currentSongId(get,never):Int;
function  get_currentSongId():Int
        {
            return this._currentSongId;
        }

        public var currentPosition(get,never):Int;
function  get_currentPosition():Int
        {
            return this._currentPosition;
        }

        public var nextSongId(get,never):Int;
function  get_nextSongId():Int
        {
            return this._nextSongId;
        }

        public var nextPosition(get,never):Int;
function  get_nextPosition():Int
        {
            return this._nextPosition;
        }

        public var syncCount(get,never):Int;
function  get_syncCount():Int
        {
            return this._syncCount;
        }

        public function flush():Bool
        {
            this._currentSongId = -1;
            this._currentPosition = -1;
            this._nextSongId = -1;
            this._nextPosition = -1;
            this._syncCount = -1;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._currentSongId = k.readInteger();
            this._currentPosition = k.readInteger();
            this._nextSongId = k.readInteger();
            this._nextPosition = k.readInteger();
            this._syncCount = k.readInteger();
            return true;
        }

	public function new() {}
    }

