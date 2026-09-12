package snowwar._str_448
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar.friendfurni.SnowStormGamesInformationParser;

     class SnowStormGamesInformationEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, SnowStormGamesInformationParser);
        }

        public function getParser():SnowStormGamesInformationParser
        {
            return Std.downcast(this._parser , SnowStormGamesInformationParser);
        }
    }

