package com.sulake.habbo.communication.messages.incoming.notifications
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.notifications.MOTDNotificationParser;

     class MOTDNotificationEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, MOTDNotificationParser);
        }

        public function getParser():MOTDNotificationParser
        {
            return Std.downcast(_parser , MOTDNotificationParser);
        }
    }

