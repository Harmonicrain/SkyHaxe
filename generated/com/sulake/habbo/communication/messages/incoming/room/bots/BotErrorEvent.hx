package com.sulake.habbo.communication.messages.incoming.room.bots
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.bots.BotErrorParser;

     class BotErrorEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, BotErrorParser);
        }

        public function getParser():BotErrorParser
        {
            return Std.downcast(_parser , BotErrorParser);
        }
    }

