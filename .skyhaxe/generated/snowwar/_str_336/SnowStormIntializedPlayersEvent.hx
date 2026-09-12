package snowwar._str_336
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar._str_277.SnowStormIntializedPlayersParser;

     class SnowStormIntializedPlayersEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormIntializedPlayersParser);
        }

        public function getParser():SnowStormIntializedPlayersParser
        {
            return Std.downcast(_parser , SnowStormIntializedPlayersParser);
        }
    }

