package com.sulake.habbo.communication.messages.incoming.games
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.games.OpenLeaderboardMessageParser;

     class OpenLeaderboardMessageEvent extends MessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, OpenLeaderboardMessageParser);
        }

        public function getParser():OpenLeaderboardMessageParser
        {
            return Std.downcast(this._parser , OpenLeaderboardMessageParser);
        }
    }

