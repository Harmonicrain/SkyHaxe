package com.sulake.habbo.communication.messages.incoming.room.action
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.action.SleepMessageParser;

     class SleepMessageEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SleepMessageParser);
        }

        public function getParser():SleepMessageParser
        {
            return Std.downcast(_parser , SleepMessageParser);
        }
    }

