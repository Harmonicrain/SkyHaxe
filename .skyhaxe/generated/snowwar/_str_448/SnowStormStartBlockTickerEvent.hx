package snowwar._str_448
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar.friendfurni.SnowStormStartBlockTickerParser;

     class SnowStormStartBlockTickerEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormStartBlockTickerParser);
        }

        public function getParser():SnowStormStartBlockTickerParser
        {
            return Std.downcast(this._parser , SnowStormStartBlockTickerParser);
        }
    }

