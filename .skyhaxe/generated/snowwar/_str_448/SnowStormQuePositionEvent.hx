package snowwar._str_448
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar.friendfurni.SnowStormQuePositionParser;

     class SnowStormQuePositionEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormQuePositionParser);
        }

        public function getParser():SnowStormQuePositionParser
        {
            return Std.downcast(this._parser , SnowStormQuePositionParser);
        }
    }

