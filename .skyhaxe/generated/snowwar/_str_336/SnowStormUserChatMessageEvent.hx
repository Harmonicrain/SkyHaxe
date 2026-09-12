package snowwar._str_336
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar._str_277.SnowStormUserChatMessageParser;

     class SnowStormUserChatMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormUserChatMessageParser);
        }

        public function getParser():SnowStormUserChatMessageParser
        {
            return Std.downcast(_parser , SnowStormUserChatMessageParser);
        }
    }

