package com.sulake.habbo.communication.messages.incoming.game.lobby
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.lobby.GameListMessageParser;

     class GameListMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, GameListMessageParser);
        }

        public function getParser():GameListMessageParser
        {
            return Std.downcast(this._parser , GameListMessageParser);
        }
    }

