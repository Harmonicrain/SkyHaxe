package com.sulake.habbo.communication.messages.incoming.room.chat
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.chat.ChatMessageParser;

     class ChatMessageEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, ChatMessageParser);
        }

        public function getParser():ChatMessageParser
        {
            return Std.downcast(_parser , ChatMessageParser);
        }
    }

