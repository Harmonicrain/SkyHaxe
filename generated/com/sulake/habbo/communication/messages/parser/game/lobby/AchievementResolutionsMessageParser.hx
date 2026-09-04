package com.sulake.habbo.communication.messages.parser.game.lobby
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.inventory.achievements.AchievementResolution;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class AchievementResolutionsMessageParser implements IMessageParser 
    {
        var _stuffId:Int = 0;
        var _achievements:Vector<AchievementResolution>;
        var _endTime:Int = 0;


        public function flush():Bool
        {
            var k:AchievementResolution;
            this._stuffId = -1;
            for (_tmp_ in this._achievements)
            {
k  = _tmp_;
                k.dispose();
            }
            this._achievements = new Vector<AchievementResolution>(0);
            this._endTime = -1;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._stuffId = k.readInteger();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._achievements.push(new AchievementResolution(k));
                _local_3++;
            }
            this._endTime = k.readInteger();
            return true;
        }

        public var stuffId(get,never):Int;
function  get_stuffId():Int
        {
            return this._stuffId;
        }

        public var achievements(get,never):Vector<AchievementResolution>;
function  get_achievements():Vector<AchievementResolution>
        {
            return this._achievements;
        }

        public var _Str_17028(get,never):Int;
function  get__Str_17028():Int
        {
            return this._endTime;
        }

	public function new() {}
    }

