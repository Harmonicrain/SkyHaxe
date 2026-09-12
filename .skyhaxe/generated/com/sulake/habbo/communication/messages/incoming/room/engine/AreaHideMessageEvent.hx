package com.sulake.habbo.communication.messages.incoming.room.engine
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.engine.AreaHideMessageParser;

     class AreaHideMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, AreaHideMessageParser);
        }

        public function getParser():AreaHideMessageParser
        {
            return Std.downcast(_parser , AreaHideMessageParser);
        }
    }

