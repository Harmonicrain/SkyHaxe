package com.sulake.habbo.communication.messages.parser.notifications
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.notifications.AchievementLevelUpData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HabboAchievementNotificationMessageParser implements IMessageParser
    {
        var _data:AchievementLevelUpData;


        public function flush():Bool
        {
            this._data = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._data = new AchievementLevelUpData(k);
            return true;
        }

        public var data(get,never):AchievementLevelUpData;
public function  get_data():AchievementLevelUpData
        {
            return this._data;
        }

	public function new() {}
    }

