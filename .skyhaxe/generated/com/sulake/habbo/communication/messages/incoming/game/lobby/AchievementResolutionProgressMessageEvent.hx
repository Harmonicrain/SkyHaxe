package com.sulake.habbo.communication.messages.incoming.game.lobby
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.lobby.AchievementResolutionProgressMessageParser;

     class AchievementResolutionProgressMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, AchievementResolutionProgressMessageParser);
        }

        public function getParser():AchievementResolutionProgressMessageParser
        {
            return Std.downcast(this._parser , AchievementResolutionProgressMessageParser);
        }
    }

