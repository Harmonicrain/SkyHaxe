package com.sulake.habbo.communication.messages.incoming.inventory.furni
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.furni.FurniListAddOrUpdateParser;

     class FurniListAddOrUpdateEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, FurniListAddOrUpdateParser);
        }

        public function getParser():FurniListAddOrUpdateParser
        {
            return Std.downcast(this._parser , FurniListAddOrUpdateParser);
        }
    }

