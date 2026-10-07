package snowwar._str_336
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar._str_277.SnowStormOnStageRunningParser;

     class SnowStormOnStageRunningEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormOnStageRunningParser);
        }

        public function getParser():SnowStormOnStageRunningParser
        {
            return Std.downcast(_parser , SnowStormOnStageRunningParser);
        }
    }

