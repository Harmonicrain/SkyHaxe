package com.sulake.habbo.communication.messages.incoming.game.lobby
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.lobby.UserGameAchievementsMessageParser;

     class UserGameAchievementsMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, UserGameAchievementsMessageParser);
        }

        public function getParser():UserGameAchievementsMessageParser
        {
            return Std.downcast(this._parser , UserGameAchievementsMessageParser);
        }
    }

