package com.sulake.habbo.navigator.cache
;
    import com.sulake.habbo.communication.messages.incoming.newnavigator.SearchResultContainer;

     class NavigatorCacheEntry 
    {
        var _key:String;
        var _payload:SearchResultContainer;
        var _createdAt:Float = Math.NaN;
        var _expiredAt:Float = Math.NaN;

        public function new(k:String, _arg_2:SearchResultContainer, _arg_3:Float, _arg_4:Float)
        {
            this._key = k;
            this._payload = _arg_2;
            this._createdAt = _arg_3;
            this._expiredAt = _arg_4;
        }

        public function _Str_19856(k:Float):Bool
        {
            return k >= this._expiredAt;
        }

        public var key(get,never):String;
public function  get_key():String
        {
            return this._key;
        }

        public var _Str_23130(get,never):SearchResultContainer;
public function  get__Str_23130():SearchResultContainer
        {
            return this._payload;
        }
    }

