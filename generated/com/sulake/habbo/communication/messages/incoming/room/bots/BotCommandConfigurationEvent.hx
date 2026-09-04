package com.sulake.habbo.communication.messages.incoming.room.bots
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.bots.BotCommandConfigurationParser;

     class BotCommandConfigurationEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, BotCommandConfigurationParser);
        }

        public function getParser():BotCommandConfigurationParser
        {
            return Std.downcast(_parser , BotCommandConfigurationParser);
        }
    }

