package com.sulake.habbo.communication.messages.parser.game.lobby
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class AchievementResolutionProgressMessageParser implements IMessageParser 
    {
        var _stuffId:Int = 0;
        var _achievementId:Int = 0;
        var _requiredLevelBadgeCode:String;
        var _userProgress:Int = 0;
        var _totalProgress:Int = 0;
        var _endTime:Int = 0;


        public function flush():Bool
        {
            this._stuffId = -1;
            this._achievementId = 0;
            this._requiredLevelBadgeCode = "";
            this._userProgress = 0;
            this._totalProgress = 0;
            this._endTime = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._stuffId = k.readInteger();
            this._achievementId = k.readInteger();
            this._requiredLevelBadgeCode = k.readString();
            this._userProgress = k.readInteger();
            this._totalProgress = k.readInteger();
            this._endTime = k.readInteger();
            return true;
        }

        public var stuffId(get,never):Int;
function  get_stuffId():Int
        {
            return this._stuffId;
        }

        public var achievementId(get,never):Int;
function  get_achievementId():Int
        {
            return this._achievementId;
        }

        public var requiredLevelBadgeCode(get,never):String;
function  get_requiredLevelBadgeCode():String
        {
            return this._requiredLevelBadgeCode;
        }

        public var userProgress(get,never):Int;
function  get_userProgress():Int
        {
            return this._userProgress;
        }

        public var _Str_18600(get,never):Int;
function  get__Str_18600():Int
        {
            return this._totalProgress;
        }

        public var _Str_17028(get,never):Int;
function  get__Str_17028():Int
        {
            return this._endTime;
        }

	public function new() {}
    }

