package com.sulake.habbo.communication.messages.incoming.room.session
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.session.CloseConnectionMessageParser;

     class CloseConnectionMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CloseConnectionMessageParser);
        }

        public function getParser():CloseConnectionMessageParser
        {
            return Std.downcast(_parser , CloseConnectionMessageParser);
        }
    }

