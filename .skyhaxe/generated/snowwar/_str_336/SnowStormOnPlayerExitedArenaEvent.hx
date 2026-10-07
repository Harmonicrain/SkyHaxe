package snowwar._str_336
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar._str_277.SnowStormOnPlayerExitedArenaParser;

     class SnowStormOnPlayerExitedArenaEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormOnPlayerExitedArenaParser);
        }

        public function getParser():SnowStormOnPlayerExitedArenaParser
        {
            return Std.downcast(_parser , SnowStormOnPlayerExitedArenaParser);
        }
    }

