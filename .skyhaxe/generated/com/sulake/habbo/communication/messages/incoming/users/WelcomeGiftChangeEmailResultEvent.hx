package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.users._Str_7457;

     class WelcomeGiftChangeEmailResultEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, _Str_7457);
        }

        public function getParser():_Str_7457
        {
            return Std.downcast(_parser , _Str_7457);
        }
    }

