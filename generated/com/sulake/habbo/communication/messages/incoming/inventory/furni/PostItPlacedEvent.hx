package com.sulake.habbo.communication.messages.incoming.inventory.furni
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.inventory.furni.PostItPlacedParser;

     class PostItPlacedEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, PostItPlacedParser);
        }

        public function getParser():PostItPlacedParser
        {
            return Std.downcast(this._parser , PostItPlacedParser);
        }
    }

