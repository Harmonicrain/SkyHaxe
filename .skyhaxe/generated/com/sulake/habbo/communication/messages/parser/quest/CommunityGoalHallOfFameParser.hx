package com.sulake.habbo.communication.messages.parser.quest
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.quest.CommunityGoalHallOfFameData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CommunityGoalHallOfFameParser implements IMessageParser 
    {
        var _data:CommunityGoalHallOfFameData;


        public function flush():Bool
        {
            this._data = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new CommunityGoalHallOfFameData(k);
            return true;
        }

        public var data(get,never):CommunityGoalHallOfFameData;
public function  get_data():CommunityGoalHallOfFameData
        {
            return this._data;
        }

	public function new() {}
    }

