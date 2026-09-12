package com.sulake.habbo.communication.messages.incoming.game.score
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.score.WeeklyGameRewardParser;

     class WeeklyGameRewardEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, WeeklyGameRewardParser);
        }

        public function getParser():WeeklyGameRewardParser
        {
            return Std.downcast(this._parser , WeeklyGameRewardParser);
        }
    }

