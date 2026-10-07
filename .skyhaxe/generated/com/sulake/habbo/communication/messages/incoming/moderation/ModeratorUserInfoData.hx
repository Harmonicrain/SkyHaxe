package com.sulake.habbo.communication.messages.incoming.moderation
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ModeratorUserInfoData
    {
        var _userId:Int = 0;
        var _userName:String;
        var _Str_19258:Int = 0;
        var _Str_20876:Int = 0;
        var _online:Bool = false;
        var _Str_21621:Int = 0;
        var _Str_20013:Int = 0;
        var _Str_20917:Int = 0;
        var _Str_20349:Int = 0;
        var _Str_21386:Int = 0;
        var _Str_20848:String;
        var _Str_21819:String;
        var _identityId:Int = 0;
        var _Str_19460:Int = 0;
        var _Str_22254:String;
        var _figure:String;
        var _Str_20625:String;
        var _Str_19116:String = "";
        var _Str_20729:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._userId = k.readInteger();
            this._userName = k.readString();
            this._figure = k.readString();
            this._Str_19258 = k.readInteger();
            this._Str_20876 = k.readInteger();
            this._online = k.readBoolean();
            this._Str_21621 = k.readInteger();
            this._Str_20013 = k.readInteger();
            this._Str_20917 = k.readInteger();
            this._Str_20349 = k.readInteger();
            this._Str_21386 = k.readInteger();
            this._Str_20848 = k.readString();
            this._Str_21819 = k.readString();
            this._identityId = k.readInteger();
            this._Str_19460 = k.readInteger();
            this._Str_22254 = k.readString();
            this._Str_20625 = k.readString();
            if (k.bytesAvailable != 0)
            {
                this._Str_19116 = k.readString();
                this._Str_20729 = k.readInteger();
            }
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return this._userName;
        }

        public var figure(get,never):String;
public function  get_figure():String
        {
            return this._figure;
        }

        public var _Str_24334(get,never):Int;
public function  get__Str_24334():Int
        {
            return this._Str_19258;
        }

        public var _Str_23276(get,never):Int;
public function  get__Str_23276():Int
        {
            return this._Str_20876;
        }

        public var online(get,never):Bool;
public function  get_online():Bool
        {
            return this._online;
        }

        public var _Str_24656(get,never):Int;
public function  get__Str_24656():Int
        {
            return this._Str_21621;
        }

        public var _Str_22987(get,never):Int;
public function  get__Str_22987():Int
        {
            return this._Str_20013;
        }

        public var _Str_16987(get,never):Int;
public function  get__Str_16987():Int
        {
            return this._Str_20917;
        }

        public var _Str_20373(get,never):Int;
public function  get__Str_20373():Int
        {
            return this._Str_20349;
        }

        public var _Str_24526(get,never):Int;
public function  get__Str_24526():Int
        {
            return this._Str_21386;
        }

        public var _Str_23969(get,never):String;
public function  get__Str_23969():String
        {
            return this._Str_20848;
        }

        public var _Str_22786(get,never):String;
public function  get__Str_22786():String
        {
            return this._Str_21819;
        }

        public var _Str_25657(get,never):Int;
public function  get__Str_25657():Int
        {
            return this._identityId;
        }

        public var _Str_22700(get,never):Int;
public function  get__Str_22700():Int
        {
            return this._Str_19460;
        }

        public var _Str_20219(get,never):String;
public function  get__Str_20219():String
        {
            return this._Str_22254;
        }

        public var _Str_22262(get,never):String;
public function  get__Str_22262():String
        {
            return this._Str_20625;
        }

        public var _Str_24447(get,never):String;
public function  get__Str_24447():String
        {
            return this._Str_19116;
        }

        public var _Str_19137(get,never):Int;
public function  get__Str_19137():Int
        {
            return this._Str_20729;
        }
    }

