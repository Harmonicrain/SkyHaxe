package com.sulake.habbo.communication.messages.incoming.inventory.achievements
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.achievements.AchievementsParser;

     class AchievementsEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, AchievementsParser);
        }

        public function getParser():AchievementsParser
        {
            return Std.downcast(_parser , AchievementsParser);
        }
    }

