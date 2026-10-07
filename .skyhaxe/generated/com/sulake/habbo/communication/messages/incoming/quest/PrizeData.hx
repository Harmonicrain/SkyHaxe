package com.sulake.habbo.communication.messages.incoming.quest
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PrizeData
    {
        var _Str_19085:Int = 0;
        var _Str_21282:String;
        var _userRank:Int = 0;
        var _Str_19212:String;
        var _badge:Bool = false;
        var _Str_12218:String;

        public function new(k:IMessageDataWrapper)
        {
            this._Str_19085 = k.readInteger();
            this._Str_21282 = k.readString();
            this._userRank = k.readInteger();
            this._Str_19212 = k.readString();
            this._badge = k.readBoolean();
            this._Str_12218 = k.readString();
        }

        public var _Str_26147(get,never):Int;
public function  get__Str_26147():Int
        {
            return this._Str_19085;
        }

        public var _Str_25933(get,never):String;
public function  get__Str_25933():String
        {
            return this._Str_21282;
        }

        public var userRank(get,never):Int;
public function  get_userRank():Int
        {
            return this._userRank;
        }

        public var _Str_26364(get,never):String;
public function  get__Str_26364():String
        {
            return this._Str_19212;
        }

        public var badge(get,never):Bool;
public function  get_badge():Bool
        {
            return this._badge;
        }

        public var localizedName(get,never):String;
public function  get_localizedName():String
        {
            return this._Str_12218;
        }
    }

