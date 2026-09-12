package snowwar._str_336
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar._str_277.SnowStormRejoinPreviousRoomParser;

     class SnowStormRejoinPreviousRoomEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormRejoinPreviousRoomParser);
        }

        public function getParser():SnowStormRejoinPreviousRoomParser
        {
            return Std.downcast(_parser , SnowStormRejoinPreviousRoomParser);
        }
    }

