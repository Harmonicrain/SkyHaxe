package snowwar._str_336
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar._str_277.SnowStormUserRematchedParser;

     class SnowStormUserRematchedEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormUserRematchedParser);
        }

        public function getParser():SnowStormUserRematchedParser
        {
            return Std.downcast(_parser , SnowStormUserRematchedParser);
        }
    }

