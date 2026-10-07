package com.sulake.habbo.communication.messages.incoming.room.bots
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.bots.BotForceOpenContextMenuParser;

     class BotForceOpenContextMenuEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, BotForceOpenContextMenuParser);
        }

        public function getParser():BotForceOpenContextMenuParser
        {
            return Std.downcast(_parser , BotForceOpenContextMenuParser);
        }
    }

