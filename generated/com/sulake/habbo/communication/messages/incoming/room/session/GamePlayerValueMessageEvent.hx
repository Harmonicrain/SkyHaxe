package com.sulake.habbo.communication.messages.incoming.room.session
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.session.GamePlayerValueMessageParser;

     class GamePlayerValueMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, GamePlayerValueMessageParser);
        }

        public function getParser():GamePlayerValueMessageParser
        {
            return Std.downcast(_parser , GamePlayerValueMessageParser);
        }
    }

