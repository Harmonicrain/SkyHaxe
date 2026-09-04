package com.sulake.habbo.communication.messages.incoming.games
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.games.OpenGameBoardMessageParser;

     class OpenGameBoardMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, OpenGameBoardMessageParser);
        }

        public function getParser():OpenGameBoardMessageParser
        {
            return Std.downcast(_parser , OpenGameBoardMessageParser);
        }
    }

