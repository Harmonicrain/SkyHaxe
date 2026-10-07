package com.sulake.habbo.communication.messages.incoming.availability
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.availability.AvailabilityStatusMessageParser;

     class AvailabilityStatusMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, AvailabilityStatusMessageParser);
        }

        public function getParser():AvailabilityStatusMessageParser
        {
            return Std.downcast(_parser , AvailabilityStatusMessageParser);
        }
    }

