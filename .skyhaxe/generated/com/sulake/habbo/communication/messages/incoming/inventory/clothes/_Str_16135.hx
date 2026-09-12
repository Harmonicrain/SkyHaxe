package com.sulake.habbo.communication.messages.incoming.inventory.clothes
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.clothing._Str_8728;

     class _Str_16135 extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, _Str_8728);
        }

        public function getParser():_Str_8728
        {
            return Std.downcast(_parser , _Str_8728);
        }
    }

