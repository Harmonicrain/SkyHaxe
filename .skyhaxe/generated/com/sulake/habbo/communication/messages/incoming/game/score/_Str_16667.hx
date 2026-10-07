package com.sulake.habbo.communication.messages.incoming.game.score
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.score.Game2LeaderboardParser;

     class _Str_16667 extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, Game2LeaderboardParser);
        }

        public function getParser():Game2LeaderboardParser
        {
            return Std.downcast(this._parser , Game2LeaderboardParser);
        }
    }

