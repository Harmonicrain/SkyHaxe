package com.sulake.habbo.communication.messages.incoming.tracking
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.tracking.LatencyPingResponseMessageParser;

     class LatencyPingResponseMessageEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, LatencyPingResponseMessageParser);
        }

        public function getParser():LatencyPingResponseMessageParser
        {
            return Std.downcast(_parser , LatencyPingResponseMessageParser);
        }
    }

