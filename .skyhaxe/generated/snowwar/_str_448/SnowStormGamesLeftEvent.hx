package snowwar._str_448
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar.friendfurni.SnowStormGamesLeftParser;

     class SnowStormGamesLeftEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormGamesLeftParser);
        }

        public function getParser():SnowStormGamesLeftParser
        {
            return Std.downcast(this._parser , SnowStormGamesLeftParser);
        }
    }

