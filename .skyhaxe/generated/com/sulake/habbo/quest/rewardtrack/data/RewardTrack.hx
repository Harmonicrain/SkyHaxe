package com.sulake.habbo.quest.rewardtrack.data
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RewardTrack
    {
        var _id:String;
        var _theme:String;
        var _points:Int = 0;
        var _hasPremiumConfig:Bool = false;
        var _taskPointsBoost:Float = 1;
        var _instantPoints:Int = 0;
        var _costPoints:Int = 0;
        var _costPointsType:Int = 5;
        var _costCredits:Int = 0;
        var _premium:Bool = false;
        var _complete:Bool = false;
        var _premiumComplete:Bool = false;
        var _tasks:Array<ASAny>;
        var _prizes:Array<ASAny>;

        public function new(wrapper:IMessageDataWrapper)
        {
var i = 0;            var i = 0;
            var count = 0;
            this._tasks = [];
            this._prizes = [];
            this._id = wrapper.readString();
            this._theme = wrapper.readString();
            this._points = wrapper.readInteger();
            this._hasPremiumConfig = wrapper.readBoolean();
            if (this._hasPremiumConfig)
            {
                this._taskPointsBoost = wrapper.readDouble();
                this._instantPoints = wrapper.readInteger();
                this._costPoints = wrapper.readInteger();
                this._costCredits = wrapper.readInteger();
                this._costPointsType = wrapper.readInteger();
            }
            this._premium = wrapper.readBoolean();
            this._complete = wrapper.readBoolean();
            this._premiumComplete = wrapper.readBoolean();
            count = wrapper.readInteger();
            for (_tmp_ in 0...count)
            {
i= _tmp_;
                this._tasks.push(new RewardTrackTask(wrapper));
            }
            count = wrapper.readInteger();
            for (_tmp_ in 0...count)
            {
i= _tmp_;
                this._prizes.push(new RewardTrackPrize(wrapper));
            }
        }

        public var id(get,never):String;
public function  get_id():String
        {
            return this._id;
        }

        public var theme(get,never):String;
public function  get_theme():String
        {
            return this._theme;
        }

        
        public var points(get,set):Int;
public function  get_points():Int
        {
            return this._points;
        }
public function  set_points(value:Int):Int        {
            return this._points = value;
        }

        public var hasPremiumConfig(get,never):Bool;
public function  get_hasPremiumConfig():Bool
        {
            return this._hasPremiumConfig;
        }

        public var taskPointsBoost(get,never):Float;
public function  get_taskPointsBoost():Float
        {
            return this._taskPointsBoost;
        }

        public var instantPoints(get,never):Int;
public function  get_instantPoints():Int
        {
            return this._instantPoints;
        }

        public var costPoints(get,never):Int;
public function  get_costPoints():Int
        {
            return this._costPoints;
        }

        public var costPointsType(get,never):Int;
public function  get_costPointsType():Int
        {
            return this._costPointsType;
        }

        public var costCredits(get,never):Int;
public function  get_costCredits():Int
        {
            return this._costCredits;
        }

        
        public var premium(get,set):Bool;
public function  get_premium():Bool
        {
            return this._premium;
        }
public function  set_premium(value:Bool):Bool        {
            return this._premium = value;
        }

        public var complete(get,never):Bool;
public function  get_complete():Bool
        {
            return this._complete;
        }

        public var premiumComplete(get,never):Bool;
public function  get_premiumComplete():Bool
        {
            return this._premiumComplete;
        }

        public var tasks(get,never):Array<ASAny>;
public function  get_tasks():Array<ASAny>
        {
            return this._tasks;
        }

        public var prizes(get,never):Array<ASAny>;
public function  get_prizes():Array<ASAny>
        {
            return this._prizes;
        }

        public var hasPremiumPrizes(get,never):Bool;
public function  get_hasPremiumPrizes():Bool
        {
            var prize:RewardTrackPrize = null;
            final _iter_ = this._prizes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
prize  = _tmp_;
                if (prize.premium)
                {
                    return true;
                }
            }
            return false;
        }

        public var hasPremiumTasks(get,never):Bool;
public function  get_hasPremiumTasks():Bool
        {
            var task:RewardTrackTask = null;
            final _iter_ = this._tasks; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
task  = _tmp_;
                if (task.premium)
                {
                    return true;
                }
            }
            return false;
        }

        public var hasPremiumLevels(get,never):Bool;
public function  get_hasPremiumLevels():Bool
        {
            var task:RewardTrackTask = null;
            var level:RewardTrackTaskLevel = null;
            final _iter_ = this._tasks; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
task  = _tmp_;
                final _iter_ = task.levels; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
level  = _tmp_;
                    if (level.premium)
                    {
                        return true;
                    }
                }
            }
            return false;
        }

        public function getTask(taskId:String):RewardTrackTask
        {
            var task:RewardTrackTask = null;
            final _iter_ = this._tasks; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
task  = _tmp_;
                if (task.id == taskId)
                {
                    return task;
                }
            }
            return null;
        }

        public function getPrize(prizeId:String):RewardTrackPrize
        {
            var prize:RewardTrackPrize = null;
            final _iter_ = this._prizes; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
prize  = _tmp_;
                if (prize.id == prizeId)
                {
                    return prize;
                }
            }
            return null;
        }
    }

