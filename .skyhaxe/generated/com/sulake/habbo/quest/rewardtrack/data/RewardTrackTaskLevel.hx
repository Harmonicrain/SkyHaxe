package com.sulake.habbo.quest.rewardtrack.data
;
     class RewardTrackTaskLevel
    {
        var _requiredCount:Int = 0;
        var _pointsReward:Int = 0;
        var _premium:Bool = false;

        public function new(requiredCount:Int, pointsReward:Int, premium:Bool)
        {
            this._requiredCount = requiredCount;
            this._pointsReward = pointsReward;
            this._premium = premium;
        }

        public var requiredCount(get,never):Int;
public function  get_requiredCount():Int
        {
            return this._requiredCount;
        }

        public var pointsReward(get,never):Int;
public function  get_pointsReward():Int
        {
            return this._pointsReward;
        }

        public var premium(get,never):Bool;
public function  get_premium():Bool
        {
            return this._premium;
        }
    }

