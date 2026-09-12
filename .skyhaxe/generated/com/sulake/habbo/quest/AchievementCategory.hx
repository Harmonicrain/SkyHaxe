package com.sulake.habbo.quest
;
    import com.sulake.habbo.communication.messages.incoming.inventory.achievements.Achievement;

     class AchievementCategory 
    {
        var _code:String;
        var _achievements:Vector<Achievement>;

        public function new(k:String)
        {
            this._achievements = new Vector<Achievement>(0);
            this._code = k;
        }

        public function add(k:Achievement)
        {
            this._achievements.push(k);
        }

        public function update(k:Achievement)
        {
            var _local_3:Achievement = null;
            var _local_2 = 0;
            while (_local_2 < this._achievements.length)
            {
                _local_3 = this._achievements[_local_2];
                if (_local_3.achievementId == k.achievementId)
                {
                    this._achievements[_local_2] = k;
                }
                _local_2++;
            }
        }

        public function _Str_9594():Int
        {
            var _local_2:Achievement = null;
            var k = 0;
            final _iter_ = this._achievements; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                k = (k + (_local_2._Str_7518 ? _local_2.level : (_local_2.level - 1)));
            }
            return k;
        }

        public function _Str_10932():Int
        {
            var _local_2:Achievement = null;
            var k = 0;
            final _iter_ = this._achievements; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                k = (k + _local_2._Str_20475);
            }
            return k;
        }

        public var code(get,never):String;
public function  get_code():String
        {
            return this._code;
        }

        public var achievements(get,never):Vector<Achievement>;
public function  get_achievements():Vector<Achievement>
        {
            return this._achievements;
        }
    }

