package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.navigator.FavouritesMessageParser;

     class FavouritesEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, FavouritesMessageParser);
        }

        public function getParser():FavouritesMessageParser
        {
            return Std.downcast(this._parser , FavouritesMessageParser);
        }
    }

