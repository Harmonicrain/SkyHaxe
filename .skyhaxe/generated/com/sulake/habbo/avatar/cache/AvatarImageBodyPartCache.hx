package com.sulake.habbo.avatar.cache
;
    import com.sulake.core.utils.Map;

     class AvatarImageBodyPartCache 
    {
        var _Str_586:Map;
        var _Str_1509:Int = 0;

        public function new()
        {
            this._Str_586 = new Map();
            this.setDirection(flash.Lib.getTimer());
        }

        public function dispose()
        {
            var k:AvatarImageDirectionCache = null;
            this._Str_587("[dispose]");
            if (this._Str_586 == null)
            {
                return;
            }
            final _iter_ = this._Str_586; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
            {
k  = _tmp_;
                k.dispose();
            }
            this._Str_586.dispose();
        }

        public function _Str_2070(k:Int):AvatarImageDirectionCache
        {
            var _local_2= Std.string(k);
            return ASCompat.dynamicAs(this._Str_586.getValue(_local_2) , AvatarImageDirectionCache);
        }

        public function _Str_2168(k:Int, _arg_2:AvatarImageDirectionCache)
        {
            var _local_3= Std.string(k);
            this._Str_586.add(_local_3, _arg_2);
        }

        public function setDirection(k:Int)
        {
            this._Str_1509 = k;
        }

        public function getDirection():Int
        {
            return this._Str_1509;
        }

        function _Str_587(k:String)
        {
        }
    }

