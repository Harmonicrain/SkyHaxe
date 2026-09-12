package com.sulake.habbo.communication.messages.incoming.quest
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CommunityGoalData implements IDisposable
    {
        var _hasGoalExpired:Bool = false;
        var _personalContributionScore:Int = 0;
        var _personalContributionRank:Int = 0;
        var _communityTotalScore:Int = 0;
        var _communityHighestAchievedLevel:Int = 0;
        var _scoreRemainingUntilNextLevel:Int = 0;
        var _percentCompletionTowardsNextLevel:Int = 0;
        var _goalCode:String;
        var _timeRemainingInSeconds:Int = 0;
        var _rewardUserLimits:Array<ASAny>;

        public function new(k:IMessageDataWrapper)        {
            this._rewardUserLimits = [];
            this._hasGoalExpired = k.readBoolean();
            this._personalContributionScore = k.readInteger();
            this._personalContributionRank = k.readInteger();
            this._communityTotalScore = k.readInteger();
            this._communityHighestAchievedLevel = k.readInteger();
            this._scoreRemainingUntilNextLevel = k.readInteger();
            this._percentCompletionTowardsNextLevel = k.readInteger();
            this._goalCode = k.readString();
            this._timeRemainingInSeconds = k.readInteger();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._rewardUserLimits.push(k.readInteger());
                _local_3++;
            }
        }

        public function dispose()
        {
            this._rewardUserLimits = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._rewardUserLimits == null;
        }

        public var _Str_13028(get,never):Bool;
public function  get__Str_13028():Bool
        {
            return this._hasGoalExpired;
        }

        public var personalContributionScore(get,never):Int;
public function  get_personalContributionScore():Int
        {
            return this._personalContributionScore;
        }

        public var _Str_10549(get,never):Int;
public function  get__Str_10549():Int
        {
            return this._personalContributionRank;
        }

        public var _Str_12030(get,never):Int;
public function  get__Str_12030():Int
        {
            return this._communityTotalScore;
        }

        public var communityHighestAchievedLevel(get,never):Int;
public function  get_communityHighestAchievedLevel():Int
        {
            return this._communityHighestAchievedLevel;
        }

        public var scoreRemainingUntilNextLevel(get,never):Int;
public function  get_scoreRemainingUntilNextLevel():Int
        {
            return this._scoreRemainingUntilNextLevel;
        }

        public var percentCompletionTowardsNextLevel(get,never):Int;
public function  get_percentCompletionTowardsNextLevel():Int
        {
            return this._percentCompletionTowardsNextLevel;
        }

        public var _Str_24637(get,never):Int;
public function  get__Str_24637():Int
        {
            return this._timeRemainingInSeconds;
        }

        public var _Str_20155(get,never):Array<ASAny>;
public function  get__Str_20155():Array<ASAny>
        {
            return this._rewardUserLimits;
        }

        public var goalCode(get,never):String;
public function  get_goalCode():String
        {
            return this._goalCode;
        }
    }

