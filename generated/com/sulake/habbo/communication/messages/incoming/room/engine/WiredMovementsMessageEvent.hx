package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.WiredMovementsMessageParser;

     class WiredMovementsMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, WiredMovementsMessageParser);
        }

        public function getParser():WiredMovementsMessageParser
        {
            return Std.downcast(_parser , WiredMovementsMessageParser);
        }
    }

