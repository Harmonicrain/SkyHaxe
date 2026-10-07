package com.sulake.habbo.communication.messages.incoming.recycler
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.recycler.RecyclerStatusMessageParser;

     class RecyclerStatusEvent extends MessageEvent implements IMessageEvent 
    {
        public static inline final _Str_16635= 1;
        public static inline final _Str_14635= 2;
        public static inline final _Str_16908= 3;

        public function new(k:ASFunction)
        {
            super(k, RecyclerStatusMessageParser);
        }

        public function getParser():RecyclerStatusMessageParser
        {
            return Std.downcast(_parser , RecyclerStatusMessageParser);
        }
    }

