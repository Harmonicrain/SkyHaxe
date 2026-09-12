package com.sulake.habbo.communication.messages.incoming.games
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.games.GameBoardUpdateMessageParser;

     class GameBoardUpdateMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GameBoardUpdateMessageParser);
        }

        public function getParser():GameBoardUpdateMessageParser
        {
            return Std.downcast(_parser , GameBoardUpdateMessageParser);
        }
    }

