package com.sulake.habbo.communication.messages.incoming.game.lobby
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.lobby.GameAchievementsMessageParser;

     class GameAchievementsMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, GameAchievementsMessageParser);
        }

        public function getParser():GameAchievementsMessageParser
        {
            return Std.downcast(this._parser , GameAchievementsMessageParser);
        }
    }

