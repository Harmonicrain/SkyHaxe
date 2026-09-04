package com.sulake.habbo.communication.messages.incoming.room.permissions
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.permissions.YouAreNotControllerMessageParser;

     class YouAreNotControllerMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, YouAreNotControllerMessageParser);
        }

        public function getParser():YouAreNotControllerMessageParser
        {
            return Std.downcast(_parser , YouAreNotControllerMessageParser);
        }
    }

