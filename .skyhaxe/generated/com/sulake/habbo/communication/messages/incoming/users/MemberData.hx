package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class MemberData
    {
        static inline final _Str_18346= 0;
        static inline final _Str_17015= 1;
        static inline final _Str_20696= 2;
        static inline final _Str_16330= 3;
        static inline final _Str_18721= 4;

        var _type:Int = 0;
        var _userId:Int = 0;
        var _userName:String;
        var _figure:String;
        var _Str_20370:String;

        public function new(k:IMessageDataWrapper)
        {
            this._type = k.readInteger();
            this._userId = k.readInteger();
            this._userName = k.readString();
            this._figure = k.readString();
            this._Str_20370 = k.readString();
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

        public var admin(get,never):Bool;
public function  get_admin():Bool
        {
            return this._type == _Str_17015;
        }

        public var owner(get,never):Bool;
public function  get_owner():Bool
        {
            return this._type == _Str_18346;
        }

        public var member(get,never):Bool;
public function  get_member():Bool
        {
            return !(this._type == _Str_16330);
        }

        public var blocked(get,never):Bool;
public function  get_blocked():Bool
        {
            return this._type == _Str_18721;
        }

        public var figure(get,never):String;
public function  get_figure():String
        {
            return this._figure;
        }

        public var _Str_20842(get,never):String;
public function  get__Str_20842():String
        {
            return this._Str_20370;
        }
    }

