package com.sulake.habbo.communication.messages.incoming.availability
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.availability.AvailabilityTimeMessageParser;

     class AvailabilityTimeMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, AvailabilityTimeMessageParser);
        }

        public function getParser():AvailabilityTimeMessageParser
        {
            return Std.downcast(_parser , AvailabilityTimeMessageParser);
        }
    }

