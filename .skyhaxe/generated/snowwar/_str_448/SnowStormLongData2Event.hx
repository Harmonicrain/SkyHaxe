package snowwar._str_448
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar.friendfurni.SnowStormLongData2Parser;

     class SnowStormLongData2Event extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormLongData2Parser);
        }

        public function getParser():SnowStormLongData2Parser
        {
            return Std.downcast(this._parser , SnowStormLongData2Parser);
        }
    }

