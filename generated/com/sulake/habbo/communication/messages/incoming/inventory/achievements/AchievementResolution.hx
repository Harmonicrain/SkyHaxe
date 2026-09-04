package com.sulake.habbo.communication.messages.incoming.inventory.achievements
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class AchievementResolution 
    {
        public static inline final _Str_16945= 0;

        var _achievementId:Int = 0;
        var _level:Int = 0;
        var _badgeId:String;
        var _requiredLevel:Int = 0;
        var _state:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._achievementId = k.readInteger();
            this._level = k.readInteger();
            this._badgeId = k.readString();
            this._requiredLevel = k.readInteger();
            this._state = k.readInteger();
        }

        public function dispose()
        {
            this._achievementId = 0;
            this._level = 0;
            this._badgeId = "";
            this._requiredLevel = 0;
        }

        public var achievementId(get,never):Int;
function  get_achievementId():Int
        {
            return this._achievementId;
        }

        public var level(get,never):Int;
function  get_level():Int
        {
            return this._level;
        }

        public var badgeId(get,never):String;
function  get_badgeId():String
        {
            return this._badgeId;
        }

        public var _Str_20240(get,never):Int;
function  get__Str_20240():Int
        {
            return this._requiredLevel;
        }

        public var enabled(get,never):Bool;
function  get_enabled():Bool
        {
            return this._state == _Str_16945;
        }

        public var state(get,never):Int;
function  get_state():Int
        {
            return this._state;
        }
    }

