package com.sulake.habbo.communication.messages.parser.game.lobby
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GameAchievementsMessageParser implements IMessageParser 
    {
        var _achievements:Vector<GameAchievementData>;


        public function flush():Bool
        {
            return true;
        }

        public var achievements(get,never):Vector<GameAchievementData>;
public function  get_achievements():Vector<GameAchievementData>
        {
            return this._achievements;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_4 = 0;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8:String = null;
            var _local_9 = 0;
            this._achievements = new Vector<GameAchievementData>();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = k.readInteger();
                _local_5 = k.readInteger();
                _local_6 = 0;
                while (_local_6 < _local_5)
                {
                    _local_7 = k.readInteger();
                    _local_8 = k.readString();
                    _local_9 = k.readInteger();
                    this._achievements.push(new GameAchievementData(_local_4, _local_7, _local_8, _local_9));
                    _local_6++;
                }
                _local_3++;
            }
            return true;
        }

	public function new() {}
    }

