package com.sulake.habbo.communication.messages.incoming.notifications
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.notifications.ElementPointerMessageParser;

     class ElementPointerMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, ElementPointerMessageParser);
        }

        public function getParser():ElementPointerMessageParser
        {
            return Std.downcast(_parser , ElementPointerMessageParser);
        }
    }

