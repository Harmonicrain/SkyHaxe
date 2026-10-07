package snowwar._str_448
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar.friendfurni.SnowStormPlayAgainParser;
    import snowwar.friendfurni.SnowStormQuePositionParser;

     class SnowStormPlayAgainEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormPlayAgainParser);
        }

        public function getParser():SnowStormQuePositionParser
        {
            return Std.downcast(this._parser , SnowStormQuePositionParser);
        }
    }

