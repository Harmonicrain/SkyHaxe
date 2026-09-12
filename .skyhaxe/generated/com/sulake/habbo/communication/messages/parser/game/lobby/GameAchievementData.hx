package com.sulake.habbo.communication.messages.parser.game.lobby
;
     class GameAchievementData
    {
        var _gameTypeId:Int = 0;
        var _achievementId:Int = 0;
        var _achievementName:String;
        var _levels:Int = 0;

        public function new(k:Int, _arg_2:Int, _arg_3:String, _arg_4:Int)
        {
            this._gameTypeId = k;
            this._achievementId = _arg_2;
            this._achievementName = _arg_3;
            this._levels = _arg_4;
        }

        public var gameTypeId(get,never):Int;
public function  get_gameTypeId():Int
        {
            return this._gameTypeId;
        }

        public var achievementId(get,never):Int;
public function  get_achievementId():Int
        {
            return this._achievementId;
        }

        public var achievementName(get,never):String;
public function  get_achievementName():String
        {
            return this._achievementName;
        }

        public var levels(get,never):Int;
public function  get_levels():Int
        {
            return this._levels;
        }
    }

