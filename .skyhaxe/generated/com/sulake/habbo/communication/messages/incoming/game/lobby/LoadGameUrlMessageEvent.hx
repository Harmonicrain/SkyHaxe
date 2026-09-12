package com.sulake.habbo.communication.messages.incoming.game.lobby
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.game.lobby.LoadGameUrlMessageParser;

     class LoadGameUrlMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, LoadGameUrlMessageParser);
        }

        public function getParser():LoadGameUrlMessageParser
        {
            return Std.downcast(this._parser , LoadGameUrlMessageParser);
        }
    }

