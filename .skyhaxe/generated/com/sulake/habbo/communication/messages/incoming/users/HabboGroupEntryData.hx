package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HabboGroupEntryData
    {
        var _groupId:Int = 0;
        var _groupName:String;
        var _badgeCode:String;
        var _Str_6751:String;
        var _Str_6979:String;
        var _favourite:Bool = false;
        var _ownerId:Int = 0;
        var _Str_19808:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            this._groupId = k.readInteger();
            this._groupName = k.readString();
            this._badgeCode = k.readString();
            this._Str_6751 = k.readString();
            this._Str_6979 = k.readString();
            this._favourite = k.readBoolean();
            this._ownerId = k.readInteger();
            this._Str_19808 = k.readBoolean();
        }

        public var groupId(get,never):Int;
public function  get_groupId():Int
        {
            return this._groupId;
        }

        public var groupName(get,never):String;
public function  get_groupName():String
        {
            return this._groupName;
        }

        public var badgeCode(get,never):String;
public function  get_badgeCode():String
        {
            return this._badgeCode;
        }

        public var _Str_5845(get,never):String;
public function  get__Str_5845():String
        {
            return this._Str_6751;
        }

        public var _Str_6659(get,never):String;
public function  get__Str_6659():String
        {
            return this._Str_6979;
        }

        public var favourite(get,never):Bool;
public function  get_favourite():Bool
        {
            return this._favourite;
        }

        public var ownerId(get,never):Int;
public function  get_ownerId():Int
        {
            return this._ownerId;
        }

        public var _Str_21674(get,never):Bool;
public function  get__Str_21674():Bool
        {
            return this._Str_19808;
        }
    }

