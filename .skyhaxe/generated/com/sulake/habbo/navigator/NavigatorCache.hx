package com.sulake.habbo.navigator
;
	import com.sulake.habbo.navigator.cache.NavigatorCacheEntry;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.SearchResultContainer;

     class NavigatorCache 
    {
        static final _Str_18368:Float = (4 * 1000);//4000

        var _Str_6451:ASDictionary<ASAny,ASAny>;

        public function new()
        {
            this._Str_6451 = new ASDictionary<ASAny,ASAny>();
        }

        public function _Str_22588(k:String, _arg_2:SearchResultContainer)
        {
            this._Str_23575();
            var _local_3:Float = flash.Lib.getTimer();
            this._Str_6451[k] = new NavigatorCacheEntry(k, _arg_2, _local_3, this._Str_25767(_local_3));
        }

        public function getEntry(k:String):SearchResultContainer
        {
            var _local_2:NavigatorCacheEntry = this._Str_6451[k];
            if (_local_2 != null)
            {
                if (_local_2._Str_19856(flash.Lib.getTimer()))
                {
                    this._Str_6451.remove(k);
                    return null;
                }
                return _local_2._Str_23130;
            }
            return null;
        }

        public function _Str_25085(k:String)
        {
            this._Str_6451.remove(k);
        }

        function _Str_23575()
        {
var k:ASObject  = null;            var k:ASObject = null;
            var _local_2:String = null;
            var _local_3:NavigatorCacheEntry = null;
            final _iter_ = this._Str_6451; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
k = _tmp_;
                _local_2 = ASCompat.toString(k);
                _local_3 = this._Str_6451[_local_2];
                if (((_local_3 == null) || _local_3._Str_19856(flash.Lib.getTimer())))
                {
                    this._Str_6451.remove(_local_2);
                }
            }
        }

        function _Str_25767(k:Float):Float
        {
            return k + _Str_18368;
        }
    }

