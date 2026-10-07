package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.HabboGroupBadgesMessageParser;
    import com.sulake.core.utils.Map;

     class HabboGroupBadgesMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, HabboGroupBadgesMessageParser);
        }

        public var badges(get,never):Map;
public function  get_badges():Map
        {
            return Std.downcast(_parser , HabboGroupBadgesMessageParser).badges;
        }
    }

