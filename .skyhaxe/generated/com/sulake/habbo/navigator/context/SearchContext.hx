package com.sulake.habbo.navigator.context
;
     class SearchContext 
    {
        var _searchCode:String;
        var _filtering:String;

        public function new(k:String, _arg_2:String)
        {
            this._searchCode = k;
            this._filtering = _arg_2;
        }

        public var searchCode(get,never):String;
public function  get_searchCode():String
        {
            return this._searchCode;
        }

        public var filtering(get,never):String;
public function  get_filtering():String
        {
            return this._filtering;
        }

        public function toString():String
        {
            return (this._searchCode + " : ") + this._filtering;
        }
    }

