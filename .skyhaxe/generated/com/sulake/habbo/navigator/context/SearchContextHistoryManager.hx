package com.sulake.habbo.navigator.context
;
    import com.sulake.habbo.navigator.HabboNewNavigator;

     class SearchContextHistoryManager 
    {
        var _contextHistory:Vector<SearchContext>;
        var _browsingOffset:Int = -1;

        public function new(k:HabboNewNavigator)
        {
            this._contextHistory = new Vector<SearchContext>(0);
        }

        public function _Str_23951(k:SearchContext):Int
        {
            if (this._contextHistory.length > (this._browsingOffset + 1))
            {
                this._contextHistory.splice((this._browsingOffset + 1), (this._contextHistory.length - this._browsingOffset));
            }
            this._contextHistory.push(k);
            return ++this._browsingOffset;
        }

        public function _Str_24998():SearchContext
        {
            if (this._Str_22168)
            {
                return this._contextHistory[--this._browsingOffset];
            }
            return null;
        }

        public function _Str_26215():SearchContext
        {
            if (this._Str_24763)
            {
                return this._contextHistory[++this._browsingOffset];
            }
            return null;
        }

        public var _Str_24763(get,never):Bool;
public function  get__Str_24763():Bool
        {
            return (this._browsingOffset + 1) < this._contextHistory.length;
        }

        public var _Str_22168(get,never):Bool;
public function  get__Str_22168():Bool
        {
            return (this._browsingOffset > 0) && (this._contextHistory.length > 0);
        }

        public function toString():String
        {
            var k= "history: [";
            var _local_2 = 0;
            while (_local_2 < this._contextHistory.length)
            {
                k = (k + this._contextHistory[_local_2].toString());
                if (_local_2 < (this._contextHistory.length - 1))
                {
                    k = (k = (k + ","));
                }
                _local_2++;
            }
            k = ((k + "] browsing offset: ") + Std.string(this._browsingOffset));
            return k;
        }
    }

