package com.sulake.habbo.communication.messages.incoming.inventory.achievements
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class Achievement 
    {
        public static inline final _Str_21736= -1;
        public static inline final _Str_21318= 0;
        public static inline final _Str_15908= 1;
        public static inline final _Str_20384= 2;

        var _achievementId:Int = 0;
        var _level:Int = 0;
        var _badgeId:String;
        var _Str_6791:Int = 0;
        var _Str_18274:Int = 0;
        var _Str_10280:Int = 0;
        var _Str_12282:Int = 0;
        var _Str_19007:Int = 0;
        var _Str_16081:Bool = false;
        var _category:String;
        var _Str_21707:String;
        var _Str_20339:Int = 0;
        var _Str_19099:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._achievementId = k.readInteger();
            this._level = k.readInteger();
            this._badgeId = k.readString();
            this._Str_6791 = k.readInteger();
            this._Str_18274 = Std.int(Math.max(1, k.readInteger()));
            this._Str_10280 = k.readInteger();
            this._Str_12282 = k.readInteger();
            this._Str_19007 = k.readInteger();
            this._Str_16081 = k.readBoolean();
            this._category = k.readString();
            this._Str_21707 = k.readString();
            this._Str_20339 = k.readInteger();
            this._Str_19099 = k.readInteger();
        }

        public var achievementId(get,never):Int;
public function  get_achievementId():Int
        {
            return this._achievementId;
        }

        public var badgeId(get,never):String;
public function  get_badgeId():String
        {
            return this._badgeId;
        }

        public var level(get,never):Int;
public function  get_level():Int
        {
            return this._level;
        }

        public var _Str_25209(get,never):Int;
public function  get__Str_25209():Int
        {
            return this._Str_6791;
        }

        public var _Str_24142(get,never):Int;
public function  get__Str_24142():Int
        {
            return this._Str_18274 - this._Str_6791;
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

        public var _Str_22939(get,never):Int;
public function  get__Str_22939():Int
        {
            return this._Str_19007 - this._Str_6791;
        }

        public var _Str_7518(get,never):Bool;
public function  get__Str_7518():Bool
        {
            return this._Str_16081;
        }

        public var category(get,never):String;
public function  get_category():String
        {
            return this._category;
        }

        public var _Str_25896(get,never):String;
public function  get__Str_25896():String
        {
            return this._Str_21707;
        }

        public var _Str_20475(get,never):Int;
public function  get__Str_20475():Int
        {
            return this._Str_20339;
        }

        public var _Str_10438(get,never):Bool;
public function  get__Str_10438():Bool
        {
            return (this._level > 1) || this._Str_16081;
        }

        public function _Str_24410()
        {
            this._Str_19007 = this._Str_18274;
        }

        public var _Str_24874(get,never):Int;
public function  get__Str_24874():Int
        {
            return this._Str_19099;
        }
    }

