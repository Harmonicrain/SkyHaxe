package com.sulake.habbo.communication.messages.incoming.game.lobby
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.lobby.LoadGameMessageParser;

     class LoadGameMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, LoadGameMessageParser);
        }

        public function getParser():LoadGameMessageParser
        {
            return Std.downcast(this._parser , LoadGameMessageParser);
        }
    }

