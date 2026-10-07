package snowwar._str_336
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar._str_277.SnowStormOnStageEndingParser;

     class SnowStormOnStageEndingEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormOnStageEndingParser);
        }

        public function getParser():SnowStormOnStageEndingParser
        {
            return Std.downcast(_parser , SnowStormOnStageEndingParser);
        }
    }

