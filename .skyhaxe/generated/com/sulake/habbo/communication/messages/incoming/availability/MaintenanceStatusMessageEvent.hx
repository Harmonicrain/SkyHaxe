package com.sulake.habbo.communication.messages.incoming.availability
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.availability.MaintenanceStatusMessageParser;

     class MaintenanceStatusMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, MaintenanceStatusMessageParser);
        }

        public function getParser():MaintenanceStatusMessageParser
        {
            return Std.downcast(_parser , MaintenanceStatusMessageParser);
        }
    }

