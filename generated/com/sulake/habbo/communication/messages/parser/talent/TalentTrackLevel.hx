package com.sulake.habbo.communication.messages.parser.talent
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.utils._Str_988;

     class TalentTrackLevel 
    {
        var _level:Int = 0;
        var _state:Int = 0;
        var _tasks:Vector<TalentTrackTask>;
        var _rewardPerks:Vector<TalentTrackRewardPerk>;
        var _rewardProducts:Vector<TalentTrackRewardProduct>;

        public function new()
        {
            this._tasks = new Vector<TalentTrackTask>();
            this._rewardPerks = new Vector<TalentTrackRewardPerk>();
            this._rewardProducts = new Vector<TalentTrackRewardProduct>();
        }

        public function parse(k:IMessageDataWrapper)
        {
            var _local_2:Int;
            var _local_3:Int;
            this._level = k.readInteger();
            this._state = k.readInteger();
            _local_3 = k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                this._tasks.push(new TalentTrackTask(k));
                _local_2++;
            }
            _local_3 = k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                this._rewardPerks.push(new TalentTrackRewardPerk(k));
                _local_2++;
            }
            _local_3 = k.readInteger();
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                this._rewardProducts.push(new TalentTrackRewardProduct(k));
                _local_2++;
            }
        }

        
        public var level(get,set):Int;
function  get_level():Int
        {
            return this._level;
        }
function  set_level(k:Int):Int        {
            return this._level = k;
        }

        
        public var state(get,set):Int;
function  get_state():Int
        {
            return this._state;
        }
function  set_state(k:Int):Int        {
            return this._state = k;
        }

        public var _Str_20997(get,never):Vector<TalentTrackTask>;
function  get__Str_20997():Vector<TalentTrackTask>
        {
            return this._tasks;
        }

        public var _Str_8893(get,never):Vector<TalentTrackRewardPerk>;
function  get__Str_8893():Vector<TalentTrackRewardPerk>
        {
            return this._rewardPerks;
        }

        public var _Str_7068(get,never):Vector<TalentTrackRewardProduct>;
function  get__Str_7068():Vector<TalentTrackRewardProduct>
        {
            return this._rewardProducts;
        }

        public var rewardCount(get,never):Int;
function  get_rewardCount():Int
        {
            return this._rewardPerks.length + this._rewardProducts.length;
        }

        public var levelProgress(get,never):Float;
function  get_levelProgress():Float
        {
            var _local_3:TalentTrackTask;
            var k= (1 / this._tasks.length);
            var _local_2:Float = 0;
            for (_tmp_ in this._tasks)
            {
_local_3  = _tmp_;
                if (_local_3.state == TalentTrack.STATE_ACHIEVED)
                {
                    _local_2 = (_local_2 + k);
                }
            }
            return _Str_988._Str_2040(_local_2);
        }

        public function _Str_17590(k:Int):TalentTrackTask
        {
            var _local_2:TalentTrackTask;
            for (_tmp_ in this._tasks)
            {
_local_2  = _tmp_;
                if (_local_2.achievementId == k)
                {
                    return _local_2;
                }
            }
            return null;
        }
    }

