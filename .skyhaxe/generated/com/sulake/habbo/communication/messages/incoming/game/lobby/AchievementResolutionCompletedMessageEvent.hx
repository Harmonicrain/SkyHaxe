package com.sulake.habbo.communication.messages.incoming.game.lobby
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.lobby.AchievementResolutionCompletedMessageParser;

     class AchievementResolutionCompletedMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, AchievementResolutionCompletedMessageParser);
        }

        public function getParser():AchievementResolutionCompletedMessageParser
        {
            return Std.downcast(this._parser , AchievementResolutionCompletedMessageParser);
        }
    }

