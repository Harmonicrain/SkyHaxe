package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredMenuErrorParser;

     final class WiredMenuErrorEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction)
        {
            super(callback, WiredMenuErrorParser);
        }

        public function getParser():WiredMenuErrorParser
        {
            return Std.downcast(_parser , WiredMenuErrorParser);
        }
    }

