package com.sulake.habbo.communication.messages.incoming.notifications
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.notifications.RestoreClientMessageParser;

     class RestoreClientMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, RestoreClientMessageParser);
        }

        public function getParser():RestoreClientMessageParser
        {
            return Std.downcast(_parser , RestoreClientMessageParser);
        }
    }

