package com.sulake.habbo.communication.messages.incoming.inventory.furni
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.furni.FurniListRemoveParser;

     class FurniListRemoveEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, FurniListRemoveParser);
        }

        public function getParser():FurniListRemoveParser
        {
            return Std.downcast(this._parser , FurniListRemoveParser);
        }
    }

