package snowwar._str_336
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar._str_277.SnowStormIntializeGameArenaViewParser;

     class SnowStormIntializeGameArenaViewEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormIntializeGameArenaViewParser);
        }

        public function getParser():SnowStormIntializeGameArenaViewParser
        {
            return Std.downcast(_parser , SnowStormIntializeGameArenaViewParser);
        }
    }

