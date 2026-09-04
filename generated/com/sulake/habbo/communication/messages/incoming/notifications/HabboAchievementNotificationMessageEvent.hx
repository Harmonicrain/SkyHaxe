package com.sulake.habbo.communication.messages.incoming.notifications
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.notifications.HabboAchievementNotificationMessageParser;

     class HabboAchievementNotificationMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, HabboAchievementNotificationMessageParser);
        }

        public function getParser():HabboAchievementNotificationMessageParser
        {
            return Std.downcast(_parser , HabboAchievementNotificationMessageParser);
        }
    }

