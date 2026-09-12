package com.sulake.habbo.quest
;
    import com.sulake.habbo.communication.messages.incoming.inventory.achievements.Achievement;

     class AchievementCategories 
    {
        var _categoryMap:ASDictionary<ASAny,ASAny>;
        var _categoryList:Vector<AchievementCategory>;

        public function new(k:Array<ASAny>)
        {
            var _local_2:AchievementCategory = null;
            var _local_3:Achievement = null;
            var _local_4:AchievementCategory = null;
            this._categoryMap = new ASDictionary<ASAny,ASAny>();
            this._categoryList = new Vector<AchievementCategory>(0);
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = _tmp_;
                if (_local_3.category == "")
                {
                }
                else
                {
                    _local_4 = this._categoryMap[_local_3.category];
                    if (_local_4 == null)
                    {
                        _local_4 = new AchievementCategory(_local_3.category);
                        this._categoryMap[_local_3.category] = _local_4;
                        if (_local_3.category != "misc")
                        {
                            this._categoryList.push(_local_4);
                        }
                        else
                        {
                            _local_2 = _local_4;
                        }
                    }
                    _local_4.add(_local_3);
                }
            }
            if (_local_2 != null)
            {
                this._categoryList.push(_local_2);
            }
        }

        public function update(k:Achievement)
        {
            if (k.category == "")
            {
                return;
            }
            var _local_2:AchievementCategory = this._categoryMap[k.category];
            _local_2.update(k);
        }

        public var _Str_16947(get,never):Vector<AchievementCategory>;
public function  get__Str_16947():Vector<AchievementCategory>
        {
            return this._categoryList;
        }

        public function _Str_10932():Int
        {
            var _local_2:AchievementCategory = null;
            var k = 0;
            final _iter_ = this._categoryList; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                k = (k + _local_2._Str_10932());
            }
            return k;
        }

        public function _Str_9594():Int
        {
            var _local_2:AchievementCategory = null;
            var k = 0;
            final _iter_ = this._categoryList; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                k = (k + _local_2._Str_9594());
            }
            return k;
        }

        public function _Str_16342(k:String):AchievementCategory
        {
            var _local_2:AchievementCategory = null;
            final _iter_ = this._categoryList; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.code == k)
                {
                    return _local_2;
                }
            }
            return null;
        }
    }

