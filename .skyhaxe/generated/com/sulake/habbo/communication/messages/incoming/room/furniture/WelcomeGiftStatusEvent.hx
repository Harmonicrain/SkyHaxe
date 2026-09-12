package com.sulake.habbo.communication.messages.incoming.room.furniture
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.furniture._Str_7719;

     class WelcomeGiftStatusEvent extends MessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, _Str_7719);
        }

        public function getParser():_Str_7719
        {
            return Std.downcast(_parser , _Str_7719);
        }
    }

