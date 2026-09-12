package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.UserRemoveMessageParser;

     class UserRemoveMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, UserRemoveMessageParser);
        }

        public function getParser():UserRemoveMessageParser
        {
            return Std.downcast(_parser , UserRemoveMessageParser);
        }
    }

