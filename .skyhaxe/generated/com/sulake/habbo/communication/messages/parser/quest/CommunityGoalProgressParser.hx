package com.sulake.habbo.communication.messages.parser.quest
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.quest.CommunityGoalData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CommunityGoalProgressParser implements IMessageParser 
    {
        var _data:CommunityGoalData;


        public function flush():Bool
        {
            this._data = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new CommunityGoalData(k);
            return true;
        }

        public var data(get,never):CommunityGoalData;
public function  get_data():CommunityGoalData
        {
            return this._data;
        }

	public function new() {}
    }

