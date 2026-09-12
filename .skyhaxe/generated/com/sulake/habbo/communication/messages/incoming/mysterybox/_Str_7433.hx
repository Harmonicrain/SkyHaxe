package com.sulake.habbo.communication.messages.incoming.mysterybox
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.mysterybox._Str_8281;

     class _Str_7433 extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, _Str_8281);
        }

        public function getParser():_Str_8281
        {
            return Std.downcast(_parser , _Str_8281);
        }
    }

