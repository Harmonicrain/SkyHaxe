package com.sulake.habbo.communication.messages.incoming.notifications
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.notifications.UnseenItemsParser;

     class UnseenItemsEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, UnseenItemsParser);
        }

        public function getParser():UnseenItemsParser
        {
            return Std.downcast(_parser , UnseenItemsParser);
        }
    }

