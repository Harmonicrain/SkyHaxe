package com.sulake.habbo.communication.messages.incoming.notifications
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class AchievementLevelUpData
    {
        var _type:Int = 0;
        var _level:Int = 0;
        var _points:Int = 0;
        var _Str_10280:Int = 0;
        var _Str_12282:Int = 0;
        var _Str_20597:Int = 0;
        var _badgeId:Int = 0;
        var _badgeCode:String = "";
        var _Str_20961:String = "";
        var _Str_20188:Int = 0;
        var _category:String;
        var _Str_20333:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            this._type = k.readInteger();
            this._level = k.readInteger();
            this._badgeId = k.readInteger();
            this._badgeCode = k.readString();
            this._points = k.readInteger();
            this._Str_10280 = k.readInteger();
            this._Str_12282 = k.readInteger();
            this._Str_20597 = k.readInteger();
            this._Str_20188 = k.readInteger();
            this._Str_20961 = k.readString();
            this._category = k.readString();
            this._Str_20333 = k.readBoolean();
        }

        public var type(get,never):Int;
public function  get_type():Int
        {
            return this._type;
        }

        public var level(get,never):Int;
public function  get_level():Int
        {
            return this._level;
        }

        public var points(get,never):Int;
public function  get_points():Int
        {
            return this._points;
        }

        public var _Str_20874(get,never):Int;
public function  get__Str_20874():Int
        {
            return this._Str_10280;
        }

        public var _Str_21187(get,never):Int;
public function  get__Str_21187():Int
        {
            return this._Str_12282;
        }

        public var _Str_26357(get,never):Int;
public function  get__Str_26357():Int
        {
            return this._Str_20597;
        }

        public var badgeId(get,never):Int;
public function  get_badgeId():Int
        {
            return this._badgeId;
        }

        public var badgeCode(get,never):String;
public function  get_badgeCode():String
        {
            return this._badgeCode;
        }

        public var _Str_24720(get,never):String;
public function  get__Str_24720():String
        {
            return this._Str_20961;
        }

        public var _Str_26165(get,never):Int;
public function  get__Str_26165():Int
        {
            return this._Str_20188;
        }

        public var category(get,never):String;
public function  get_category():String
        {
            return this._category;
        }

        public var _Str_26275(get,never):Bool;
public function  get__Str_26275():Bool
        {
            return this._Str_20333;
        }
    }

