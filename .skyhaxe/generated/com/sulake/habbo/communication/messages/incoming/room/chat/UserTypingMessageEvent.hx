package com.sulake.habbo.communication.messages.incoming.room.chat
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.chat.UserTypingMessageParser;

     class UserTypingMessageEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, UserTypingMessageParser);
        }

        public function getParser():UserTypingMessageParser
        {
            return Std.downcast(_parser , UserTypingMessageParser);
        }
    }

