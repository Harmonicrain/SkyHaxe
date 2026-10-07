package com.sulake.habbo.moderation
;
     class ModActionDefinition 
    {
        public static inline final ALERT= 1;
        public static inline final MUTE= 2;
        public static inline final BAN= 3;
        public static inline final KICK= 4;
        public static inline final TRADING_LOCK= 5;
        public static inline final MESSAGE= 6;

        var _actionId:Int = 0;
        var _name:String;
        var _actionType:Int = 0;
        var _sanctionTypeId:Int = 0;
        var _actionLengthHours:Int = 0;

        public function new(k:Int, _arg_2:String, _arg_3:Int, _arg_4:Int, _arg_5:Int)
        {
            this._actionId = k;
            this._name = _arg_2;
            this._actionType = _arg_3;
            this._sanctionTypeId = _arg_4;
            this._actionLengthHours = _arg_5;
        }

        public var actionId(get,never):Int;
public function  get_actionId():Int
        {
            return this._actionId;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var actionType(get,never):Int;
public function  get_actionType():Int
        {
            return this._actionType;
        }

        public var _Str_22995(get,never):Int;
public function  get__Str_22995():Int
        {
            return this._sanctionTypeId;
        }

        public var _Str_25670(get,never):Int;
public function  get__Str_25670():Int
        {
            return this._actionLengthHours;
        }
    }

