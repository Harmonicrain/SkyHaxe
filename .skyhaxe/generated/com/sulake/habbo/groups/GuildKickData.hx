package com.sulake.habbo.groups
;
     class GuildKickData 
    {
        var _kickTargetId:Int = 0;
        var _kickGuildId:Int = 0;
        var _targetBlocked:Bool = false;

        public function new(k:Int, _arg_2:Int, _arg_3:Bool=false)
        {
            this._kickTargetId = k;
            this._kickGuildId = _arg_2;
            this._targetBlocked = _arg_3;
        }

        public var _Str_25813(get,never):Int;
public function  get__Str_25813():Int
        {
            return this._kickTargetId;
        }

        public var _Str_23057(get,never):Int;
public function  get__Str_23057():Int
        {
            return this._kickGuildId;
        }

        public var _Str_21067(get,never):Bool;
public function  get__Str_21067():Bool
        {
            return this._targetBlocked;
        }
    }

