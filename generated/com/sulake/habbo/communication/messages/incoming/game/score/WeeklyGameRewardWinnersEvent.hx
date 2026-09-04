package com.sulake.habbo.communication.messages.incoming.game.score
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.score.WeeklyGameRewardWinnersParser;

     class WeeklyGameRewardWinnersEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, WeeklyGameRewardWinnersParser);
        }

        public function getParser():WeeklyGameRewardWinnersParser
        {
            return Std.downcast(this._parser , WeeklyGameRewardWinnersParser);
        }
    }

