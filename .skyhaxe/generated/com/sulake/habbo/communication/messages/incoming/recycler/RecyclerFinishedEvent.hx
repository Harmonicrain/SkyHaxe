package com.sulake.habbo.communication.messages.incoming.recycler
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.recycler.RecyclerFinishedMessageParser;

     class RecyclerFinishedEvent extends MessageEvent implements IMessageEvent 
    {
        public static inline final _Str_15052= 1;
        public static inline final _Str_18717= 2;

        public function new(k:ASFunction)
        {
            super(k, RecyclerFinishedMessageParser);
        }

        public function getParser():RecyclerFinishedMessageParser
        {
            return Std.downcast(_parser , RecyclerFinishedMessageParser);
        }
    }

