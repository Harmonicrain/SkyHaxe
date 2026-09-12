package snowwar._str_448
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar.friendfurni.SnowStormLongDataParser;

     class SnowStormLongDataEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormLongDataParser);
        }

        public function getParser():SnowStormLongDataParser
        {
            return Std.downcast(this._parser , SnowStormLongDataParser);
        }
    }

