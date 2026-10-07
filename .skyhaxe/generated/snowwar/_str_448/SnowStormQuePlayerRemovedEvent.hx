package snowwar._str_448
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar.friendfurni.SnowStormQuePlayerRemovedParser;

     class SnowStormQuePlayerRemovedEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormQuePlayerRemovedParser);
        }

        public function getParser():SnowStormQuePlayerRemovedParser
        {
            return Std.downcast(this._parser , SnowStormQuePlayerRemovedParser);
        }
    }

