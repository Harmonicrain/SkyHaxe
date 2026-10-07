package com.sulake.habbo.communication.messages.parser.game.lobby
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.parser.inventory.achievements.AchievementsParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class UserGameAchievementsMessageParser implements IMessageParser 
    {
        var _gameTypeId:Int = 0;
        var _achievements:AchievementsParser;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._gameTypeId = k.readInteger();
            this._achievements = new AchievementsParser();
            this._achievements.parse(k);
            return true;
        }

        public var gameTypeId(get,never):Int;
public function  get_gameTypeId():Int
        {
            return this._gameTypeId;
        }

        public var achievements(get,never):Array<ASAny>;
public function  get_achievements():Array<ASAny>
        {
            return this._achievements.achievements;
        }

        public var defaultCategory(get,never):String;
public function  get_defaultCategory():String
        {
            return this._achievements.defaultCategory;
        }

	public function new() {}
    }

