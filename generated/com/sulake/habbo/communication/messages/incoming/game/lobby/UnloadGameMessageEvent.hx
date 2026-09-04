package com.sulake.habbo.communication.messages.incoming.game.lobby
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.lobby.UnloadGameMessageParser;

     class UnloadGameMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, UnloadGameMessageParser);
        }

        public function getParser():UnloadGameMessageParser
        {
            return Std.downcast(this._parser , UnloadGameMessageParser);
        }
    }

