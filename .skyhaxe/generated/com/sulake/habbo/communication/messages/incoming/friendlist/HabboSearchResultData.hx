package com.sulake.habbo.communication.messages.incoming.friendlist
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HabboSearchResultData
    {
        var _avatarId:Int = 0;
        var _Str_20176:String;
        var _Str_20869:String;
        var _Str_22211:Bool = false;
        var _Str_22196:Bool = false;
        var _Str_20221:Int = 0;
        var _Str_19188:String;
        var _Str_25824:String;
        var _realName:String;

        public function new(k:IMessageDataWrapper)
        {
            this._avatarId = k.readInteger();
            this._Str_20176 = k.readString();
            this._Str_20869 = k.readString();
            this._Str_22211 = k.readBoolean();
            this._Str_22196 = k.readBoolean();
            k.readString();
            this._Str_20221 = k.readInteger();
            this._Str_19188 = k.readString();
            this._realName = k.readString();
        }

        public var avatarId(get,never):Int;
public function  get_avatarId():Int
        {
            return this._avatarId;
        }

        public var _Str_8751(get,never):String;
public function  get__Str_8751():String
        {
            return this._Str_20176;
        }

        public var _Str_25898(get,never):String;
public function  get__Str_25898():String
        {
            return this._Str_20869;
        }

        public var _Str_25717(get,never):Bool;
public function  get__Str_25717():Bool
        {
            return this._Str_22211;
        }

        public var _Str_26319(get,never):Bool;
public function  get__Str_26319():Bool
        {
            return this._Str_22196;
        }

        public var _Str_26027(get,never):Int;
public function  get__Str_26027():Int
        {
            return this._Str_20221;
        }

        public var _Str_17102(get,never):String;
public function  get__Str_17102():String
        {
            return this._Str_19188;
        }

        public var _Str_25904(get,never):String;
public function  get__Str_25904():String
        {
            return this._Str_25824;
        }

        public var realName(get,never):String;
public function  get_realName():String
        {
            return this._realName;
        }
    }

