package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users.AccountSafetyLockStatusChangeMessageParser;

     class AccountSafetyLockStatusChangeMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, AccountSafetyLockStatusChangeMessageParser);
        }

        public function getParser():AccountSafetyLockStatusChangeMessageParser
        {
            return Std.downcast(_parser , AccountSafetyLockStatusChangeMessageParser);
        }
    }

