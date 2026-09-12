package snowwar._str_448
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar.friendfurni.SnowStormGameEndedParser;

     class SnowStormGameEndedEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormGameEndedParser);
        }

        public function getParser():SnowStormGameEndedParser
        {
            return Std.downcast(this._parser , SnowStormGameEndedParser);
        }
    }

