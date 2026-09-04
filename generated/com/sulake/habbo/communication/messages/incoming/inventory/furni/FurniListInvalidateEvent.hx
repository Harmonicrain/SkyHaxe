package com.sulake.habbo.communication.messages.incoming.inventory.furni
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.furni.FurniListInvalidateParser;

     class FurniListInvalidateEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, FurniListInvalidateParser);
        }

        public function getParser():FurniListInvalidateParser
        {
            return Std.downcast(this._parser , FurniListInvalidateParser);
        }
    }

