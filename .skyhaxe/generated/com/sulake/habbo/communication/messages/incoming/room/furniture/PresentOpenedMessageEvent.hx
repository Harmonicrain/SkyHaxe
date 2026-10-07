package com.sulake.habbo.communication.messages.incoming.room.furniture
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.furniture.PresentOpenedMessageParser;

     class PresentOpenedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, PresentOpenedMessageParser);
        }

        public function getParser():PresentOpenedMessageParser
        {
            return Std.downcast(_parser , PresentOpenedMessageParser);
        }
    }

