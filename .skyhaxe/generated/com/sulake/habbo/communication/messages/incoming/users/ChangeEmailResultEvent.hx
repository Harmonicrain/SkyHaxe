package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.ChangeEmailResultParser;

     class ChangeEmailResultEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ChangeEmailResultParser);
        }

        public function getParser():ChangeEmailResultParser
        {
            return Std.downcast(_parser , ChangeEmailResultParser);
        }
    }

