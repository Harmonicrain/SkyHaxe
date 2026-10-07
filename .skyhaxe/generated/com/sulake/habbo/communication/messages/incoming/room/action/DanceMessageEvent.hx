package com.sulake.habbo.communication.messages.incoming.room.action
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.action.DanceMessageParser;

     class DanceMessageEvent extends MessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, DanceMessageParser);
        }

        public function getParser():DanceMessageParser
        {
            return Std.downcast(_parser , DanceMessageParser);
        }
    }

