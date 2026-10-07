package com.sulake.habbo.communication.messages.incoming.room.session
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.session.FlatAccessibleMessageParser;

     class FlatAccessibleMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, FlatAccessibleMessageParser);
        }

        public function getParser():FlatAccessibleMessageParser
        {
            return Std.downcast(_parser , FlatAccessibleMessageParser);
        }
    }

