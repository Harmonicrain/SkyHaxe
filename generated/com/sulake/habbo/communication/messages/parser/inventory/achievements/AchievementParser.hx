package com.sulake.habbo.communication.messages.parser.inventory.achievements
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.inventory.achievements.Achievement;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class AchievementParser implements IMessageParser 
    {
        var _achievement:Achievement;


        public function flush():Bool
        {
            this._achievement = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._achievement = new Achievement(k);
            return true;
        }

        public var achievement(get,never):Achievement;
function  get_achievement():Achievement
        {
            return this._achievement;
        }

	public function new() {}
    }

