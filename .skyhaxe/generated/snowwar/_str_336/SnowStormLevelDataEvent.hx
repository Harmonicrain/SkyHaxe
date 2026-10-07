package snowwar._str_336
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar._str_277.SnowStormLevelDataParser;

     class SnowStormLevelDataEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormLevelDataParser);
        }

        public function getParser():SnowStormLevelDataParser
        {
            return Std.downcast(_parser , SnowStormLevelDataParser);
        }
    }

