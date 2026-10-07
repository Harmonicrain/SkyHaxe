package snowwar._str_343
;
    import com.sulake.core.communication.messages.MessageEvent;
	import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar._str_512.SnowStormGameStatusParser;

     class SnowStormGameStatusEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormGameStatusParser);
        }

        public function getParser():SnowStormGameStatusParser
        {
            return Std.downcast(this._parser , SnowStormGameStatusParser);
        }
    }

