package snowwar._str_336
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar._str_277._SafeStr_4568;

     class _SafeStr_3669 extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, _SafeStr_4568);
        }

        public function getParser():_SafeStr_4568
        {
            return Std.downcast(_parser , _SafeStr_4568);
        }
    }

