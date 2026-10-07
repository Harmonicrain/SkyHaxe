package com.sulake.habbo.communication.messages.incoming.navigator
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.navigator.FavouriteChangedMessageParser;

     class FavouriteChangedEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, FavouriteChangedMessageParser);
        }

        public function getParser():FavouriteChangedMessageParser
        {
            return Std.downcast(this._parser , FavouriteChangedMessageParser);
        }
    }

