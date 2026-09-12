package com.sulake.habbo.communication.messages.incoming.recycler
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.recycler.RecyclerPrizesMessageParser;

     class RecyclerPrizesEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, RecyclerPrizesMessageParser);
        }

        public function getParser():RecyclerPrizesMessageParser
        {
            return Std.downcast(_parser , RecyclerPrizesMessageParser);
        }
    }

