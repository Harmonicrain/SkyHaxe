package com.sulake.habbo.communication.messages.incoming.game.score
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.score.Game2WeeklyLeaderboardParser;

     class WeeklyCompetitiveLeaderboardEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, Game2WeeklyLeaderboardParser);
        }

        public function getParser():Game2WeeklyLeaderboardParser
        {
            return Std.downcast(this._parser , Game2WeeklyLeaderboardParser);
        }
    }

