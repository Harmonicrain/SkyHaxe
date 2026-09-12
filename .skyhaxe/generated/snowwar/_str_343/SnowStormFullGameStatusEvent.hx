package snowwar._str_343
;
	import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import snowwar._str_512.SnowStormFullGameStatusParser;

     class SnowStormFullGameStatusEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormFullGameStatusParser);
        }

        public function getParser():SnowStormFullGameStatusParser
        {
            return Std.downcast(this._parser , SnowStormFullGameStatusParser);
        }
    }

