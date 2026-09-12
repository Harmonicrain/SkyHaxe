package snowwar._str_336
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar._str_277.SnowStormOnStageStartParser;

     class SnowStormOnStageStartEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormOnStageStartParser);
        }

        public function getParser():SnowStormOnStageStartParser
        {
            return Std.downcast(_parser , SnowStormOnStageStartParser);
        }
    }

