package com.sulake.habbo.communication.messages.incoming.room.furniture
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.room.furniture.OneWayDoorStatusMessageParser;

     class OneWayDoorStatusMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, OneWayDoorStatusMessageParser);
        }

        public function getParser():OneWayDoorStatusMessageParser
        {
            return Std.downcast(_parser , OneWayDoorStatusMessageParser);
        }
    }

