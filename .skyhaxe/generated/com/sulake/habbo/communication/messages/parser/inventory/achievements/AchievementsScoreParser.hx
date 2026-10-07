package com.sulake.habbo.communication.messages.parser.inventory.achievements
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class AchievementsScoreParser implements IMessageParser 
    {
        var _score:Int = 0;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._score = k.readInteger();
            return true;
        }

        public var score(get,never):Int;
public function  get_score():Int
        {
            return this._score;
        }

	public function new() {}
    }

