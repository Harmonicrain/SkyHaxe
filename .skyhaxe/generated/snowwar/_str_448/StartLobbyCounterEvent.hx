package snowwar._str_448
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import snowwar.friendfurni.StartLobbyCounterParser;

     class StartLobbyCounterEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, StartLobbyCounterParser);
        }

        public function getParser():StartLobbyCounterParser
        {
            return Std.downcast(this._parser , StartLobbyCounterParser);
        }
    }

