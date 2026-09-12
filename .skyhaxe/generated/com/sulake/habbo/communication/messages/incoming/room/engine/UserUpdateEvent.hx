package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.UserUpdateMessageParser;

     class UserUpdateEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, UserUpdateMessageParser);
        }

        public function getParser():UserUpdateMessageParser
        {
            return Std.downcast(_parser , UserUpdateMessageParser);
        }
    }

