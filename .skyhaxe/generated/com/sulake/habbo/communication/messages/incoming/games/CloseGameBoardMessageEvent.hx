package com.sulake.habbo.communication.messages.incoming.games
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.games.CloseGameBoardMessageParser;

     class CloseGameBoardMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CloseGameBoardMessageParser);
        }

        public function getParser():CloseGameBoardMessageParser
        {
            return Std.downcast(_parser , CloseGameBoardMessageParser);
        }
    }

