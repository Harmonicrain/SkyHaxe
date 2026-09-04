package com.sulake.habbo.avatar.cache
;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.avatar.actions.IActiveActionData;

     class AvatarImageActionCache 
    {
        var _Str_586:Map;
        var _Str_1233:IActiveActionData;
        var _Str_1188:Int = 0;
        var _disposed:Bool = false;

        public function new()
        {
            this._Str_586 = new Map();
        }

        public function _Str_1565(k:IActiveActionData, _arg_2:Int)
        {
            if (this._Str_1233 == null)
            {
                this._Str_1233 = k;
            }
            var _local_3= this._Str_1961(this._Str_1233);
            if (_local_3 != null)
            {
                _local_3.setDirection(_arg_2);
            }
            this._Str_1233 = k;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._Str_586 == null)
                {
                    return;
                }
                if (this._Str_586 != null)
                {
                    this._Str_2089(0, ASCompat.MAX_INT);
                    this._Str_586.dispose();
                    this._Str_586 = null;
                }
                this._disposed = true;
            }
        }

        public function _Str_2089(k:Int, _arg_2:Int)
        {
            var _local_3:Int;
            var _local_4:AvatarImageBodyPartCache;
            var _local_6:String;
            if (((this._Str_586 == null) || this._disposed))
            {
                return;
            }
            var _local_5= this._Str_586.getKeys();
            for (_tmp_ in _local_5)
            {
_local_6  = _tmp_;
                _local_4 = ASCompat.dynamicAs(this._Str_586.getValue(_local_6) , AvatarImageBodyPartCache);
                if (_local_4 != null)
                {
                    _local_3 = _local_4.getDirection();
                    if ((_arg_2 - _local_3) >= k)
                    {
                        _local_4.dispose();
                        this._Str_586.remove(_local_6);
                    }
                }
            }
        }

        public function getAction():IActiveActionData
        {
            return this._Str_1233;
        }

        public function setDirection(k:Int)
        {
            this._Str_1188 = k;
        }

        public function getDirection():Int
        {
            return this._Str_1188;
        }

        public function _Str_1961(k:IActiveActionData=null):AvatarImageBodyPartCache
        {
            if (this._Str_1233 == null)
            {
                return null;
            }
            if (k == null)
            {
                k = this._Str_1233;
            }
            if (k.overridingAction != null)
            {
                return ASCompat.dynamicAs(this._Str_586.getValue(k.overridingAction) , AvatarImageBodyPartCache);
            }
            return ASCompat.dynamicAs(this._Str_586.getValue(k.id) , AvatarImageBodyPartCache);
        }

        public function _Str_1765(k:IActiveActionData, _arg_2:AvatarImageBodyPartCache)
        {
            if (k.overridingAction != null)
            {
                this._Str_586.add(k.overridingAction, _arg_2);
            }
            else
            {
                this._Str_586.add(k.id, _arg_2);
            }
        }

        function _Str_587(k:String)
        {
        }
    }

