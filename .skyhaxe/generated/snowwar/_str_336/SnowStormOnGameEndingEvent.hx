package snowwar._str_336
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar._str_277.SnowStormOnGameEndingParser;

     class SnowStormOnGameEndingEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormOnGameEndingParser);
        }

        public function getParser():SnowStormOnGameEndingParser
        {
            return Std.downcast(_parser , SnowStormOnGameEndingParser);
        }
    }

