package com.sulake.habbo.communication.messages.incoming.newnavigator
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SavedSearch 
    {
        var _id:Int = 0;
        var _searchCode:String;
        var _filter:String;
        var _localization:String;

        public function new(k:IMessageDataWrapper)
        {
            this._id = k.readInteger();
            this._searchCode = k.readString();
            this._filter = k.readString();
            this._localization = k.readString();
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var searchCode(get,never):String;
public function  get_searchCode():String
        {
            return this._searchCode;
        }

        public var filter(get,never):String;
public function  get_filter():String
        {
            return this._filter;
        }

        public var localization(get,never):String;
public function  get_localization():String
        {
            return this._localization;
        }
    }

