package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.ClubGiftInfoParser;

     class ClubGiftInfoEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ClubGiftInfoParser);
        }

        public function getParser():ClubGiftInfoParser
        {
            return Std.downcast(this._parser , ClubGiftInfoParser);
        }
    }

