package snowwar._str_448
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar.friendfurni.SnowStormQuePlayerAddedParser;

     class SnowStormQuePlayerAddedEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormQuePlayerAddedParser);
        }

        public function getParser():SnowStormQuePlayerAddedParser
        {
            return Std.downcast(this._parser , SnowStormQuePlayerAddedParser);
        }
    }

