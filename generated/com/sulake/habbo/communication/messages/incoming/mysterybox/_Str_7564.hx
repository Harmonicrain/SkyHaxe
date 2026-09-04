package com.sulake.habbo.communication.messages.incoming.mysterybox
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.mysterybox._Str_9603;

     class _Str_7564 extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, _Str_9603);
        }

        public function getParser():_Str_9603
        {
            return Std.downcast(_parser , _Str_9603);
        }
    }

