package snowwar._str_336
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar._str_277.SnowStormGenericErrorParser2;

     class SnowStormGenericErrorEvent2 extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormGenericErrorParser2);
        }

        public function getParser():SnowStormGenericErrorParser2
        {
            return Std.downcast(_parser , SnowStormGenericErrorParser2);
        }
    }

