package snowwar._str_448
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar.friendfurni._SafeStr_4642;

     class _SafeStr_3929 extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, _SafeStr_4642);
        }

        public function getParser():_SafeStr_4642
        {
            return Std.downcast(this._parser , _SafeStr_4642);
        }
    }

