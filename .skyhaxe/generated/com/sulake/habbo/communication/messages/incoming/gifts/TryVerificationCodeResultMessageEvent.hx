package com.sulake.habbo.communication.messages.incoming.gifts
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.gifts.TryVerificationCodeResultParser;

     class TryVerificationCodeResultMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, TryVerificationCodeResultParser);
        }

        public function getParser():TryVerificationCodeResultParser
        {
            return Std.downcast(_parser , TryVerificationCodeResultParser);
        }
    }

