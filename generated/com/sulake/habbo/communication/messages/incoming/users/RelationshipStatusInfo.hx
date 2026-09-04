package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RelationshipStatusInfo
    {
        var _Str_22032:Int = 0;
        var _friendCount:Int = 0;
        var _Str_19585:Int = 0;
        var _Str_21862:String;
        var _Str_20718:String;

        public function new(k:IMessageDataWrapper)
        {
            this._Str_22032 = k.readInteger();
            this._friendCount = k.readInteger();
            this._Str_19585 = k.readInteger();
            this._Str_21862 = k.readString();
            this._Str_20718 = k.readString();
        }

        public var _Str_24791(get,never):Int;
function  get__Str_24791():Int
        {
            return this._Str_22032;
        }

        public var friendCount(get,never):Int;
function  get_friendCount():Int
        {
            return this._friendCount;
        }

        public var _Str_21077(get,never):Int;
function  get__Str_21077():Int
        {
            return this._Str_19585;
        }

        public var _Str_20359(get,never):String;
function  get__Str_20359():String
        {
            return this._Str_21862;
        }

        public var _Str_22960(get,never):String;
function  get__Str_22960():String
        {
            return this._Str_20718;
        }
    }

