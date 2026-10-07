package com.sulake.habbo.communication.messages.incoming.room.permissions
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.permissions.YouAreOwnerMessageParser;

     class YouAreOwnerMessageEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, YouAreOwnerMessageParser);
        }

        public function getParser():YouAreOwnerMessageParser
        {
            return Std.downcast(_parser , YouAreOwnerMessageParser);
        }
    }

