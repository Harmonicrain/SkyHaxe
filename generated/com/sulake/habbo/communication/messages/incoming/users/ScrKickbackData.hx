package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ScrKickbackData 
    {
        var _currentHcStreak:Int = 0;
        var _firstSubscriptionDate:String;
        var _kickbackPercentage:Float = Math.NaN;
        var _totalCreditsMissed:Int = 0;
        var _totalCreditsRewarded:Int = 0;
        var _totalCreditsSpent:Int = 0;
        var _creditRewardForStreakBonus:Int = 0;
        var _creditRewardForMonthlySpent:Int = 0;
        var _timeUntilPayday:Int = 0;

        public function new(k:IMessageDataWrapper=null)
        {
            this._currentHcStreak = k.readInteger();
            this._firstSubscriptionDate = k.readString();
            this._kickbackPercentage = k.readDouble();
            this._totalCreditsMissed = k.readInteger();
            this._totalCreditsRewarded = k.readInteger();
            this._totalCreditsSpent = k.readInteger();
            this._creditRewardForStreakBonus = k.readInteger();
            this._creditRewardForMonthlySpent = k.readInteger();
            this._timeUntilPayday = k.readInteger();
        }

        public var currentHcStreak(get,never):Int;
function  get_currentHcStreak():Int
        {
            return this._currentHcStreak;
        }

        public var firstSubscriptionDate(get,never):String;
function  get_firstSubscriptionDate():String
        {
            return this._firstSubscriptionDate;
        }

        public var kickbackPercentage(get,never):Float;
function  get_kickbackPercentage():Float
        {
            return this._kickbackPercentage;
        }

        public var totalCreditsMissed(get,never):Int;
function  get_totalCreditsMissed():Int
        {
            return this._totalCreditsMissed;
        }

        public var totalCreditsRewarded(get,never):Int;
function  get_totalCreditsRewarded():Int
        {
            return this._totalCreditsRewarded;
        }

        public var totalCreditsSpent(get,never):Int;
function  get_totalCreditsSpent():Int
        {
            return this._totalCreditsSpent;
        }

        public var creditRewardForStreakBonus(get,never):Int;
function  get_creditRewardForStreakBonus():Int
        {
            return this._creditRewardForStreakBonus;
        }

        public var creditRewardForMonthlySpent(get,never):Int;
function  get_creditRewardForMonthlySpent():Int
        {
            return this._creditRewardForMonthlySpent;
        }

        public var timeUntilPayday(get,never):Int;
function  get_timeUntilPayday():Int
        {
            return this._timeUntilPayday;
        }
    }

