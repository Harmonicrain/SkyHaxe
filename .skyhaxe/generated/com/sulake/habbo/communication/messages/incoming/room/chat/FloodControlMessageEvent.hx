package com.sulake.habbo.communication.messages.incoming.room.chat
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.chat.FloodControlMessageParser;

     class FloodControlMessageEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, FloodControlMessageParser);
        }

        public function getParser():FloodControlMessageParser
        {
            return Std.downcast(_parser , FloodControlMessageParser);
        }
    }

