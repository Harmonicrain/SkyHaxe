package com.sulake.habbo.communication.messages.incoming.gifts
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.gifts.TryPhoneNumberResultParser;

     class TryPhoneNumberResultMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, TryPhoneNumberResultParser);
        }

        public function getParser():TryPhoneNumberResultParser
        {
            return Std.downcast(_parser , TryPhoneNumberResultParser);
        }
    }

