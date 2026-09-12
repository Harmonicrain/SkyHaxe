package snowwar._str_448
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar.friendfurni.SnowStormGenericErrorParser;

     class SnowStormGenericErrorEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormGenericErrorParser);
        }

        public function getParser():SnowStormGenericErrorParser
        {
            return Std.downcast(this._parser , SnowStormGenericErrorParser);
        }
    }

