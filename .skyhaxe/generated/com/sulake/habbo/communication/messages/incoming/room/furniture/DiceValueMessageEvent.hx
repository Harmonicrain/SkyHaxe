package com.sulake.habbo.communication.messages.incoming.room.furniture
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.furniture.DiceValueMessageParser;

     class DiceValueMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, DiceValueMessageParser);
        }

        public function getParser():DiceValueMessageParser
        {
            return Std.downcast(_parser , DiceValueMessageParser);
        }
    }

