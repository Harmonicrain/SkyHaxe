package snowwar._str_448
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar.friendfurni.SnowStormGameStartedParser;

     class SnowStormGameStartedEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormGameStartedParser);
        }

        public function getParser():SnowStormGameStartedParser
        {
            return Std.downcast(this._parser , SnowStormGameStartedParser);
        }
    }

