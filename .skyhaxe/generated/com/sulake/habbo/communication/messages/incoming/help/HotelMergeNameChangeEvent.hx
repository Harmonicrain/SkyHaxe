package com.sulake.habbo.communication.messages.incoming.help
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.help.HotelMergeNameChangeParser;

     class HotelMergeNameChangeEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, HotelMergeNameChangeParser);
        }

        public function getParser():HotelMergeNameChangeParser
        {
            return Std.downcast(_parser , HotelMergeNameChangeParser);
        }
    }

