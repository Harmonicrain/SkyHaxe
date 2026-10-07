package com.sulake.habbo.communication.messages.incoming.notifications
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.notifications.NotificationDialogMessageParser;

     class NotificationDialogMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, NotificationDialogMessageParser);
        }

        public function getParser():NotificationDialogMessageParser
        {
            return Std.downcast(_parser , NotificationDialogMessageParser);
        }
    }

