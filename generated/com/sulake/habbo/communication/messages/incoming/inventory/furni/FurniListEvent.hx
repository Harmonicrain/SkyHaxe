package com.sulake.habbo.communication.messages.incoming.inventory.furni
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.furni.FurniListParser;

     class FurniListEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, FurniListParser);
        }

        public function getParser():FurniListParser
        {
            return Std.downcast(this._parser , FurniListParser);
        }
    }

