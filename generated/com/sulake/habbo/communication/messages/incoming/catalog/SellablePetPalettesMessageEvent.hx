package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.SellablePetPalettesParser;

     class SellablePetPalettesMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, SellablePetPalettesParser);
        }

        public function getParser():SellablePetPalettesParser
        {
            return Std.downcast(this._parser , SellablePetPalettesParser);
        }
    }

