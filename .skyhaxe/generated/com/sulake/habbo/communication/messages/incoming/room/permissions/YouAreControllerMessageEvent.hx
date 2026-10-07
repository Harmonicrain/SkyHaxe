package com.sulake.habbo.communication.messages.incoming.room.permissions
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.permissions.YouAreControllerMessageParser;

     class YouAreControllerMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, YouAreControllerMessageParser);
        }

        public function getParser():YouAreControllerMessageParser
        {
            return Std.downcast(_parser , YouAreControllerMessageParser);
        }
    }

