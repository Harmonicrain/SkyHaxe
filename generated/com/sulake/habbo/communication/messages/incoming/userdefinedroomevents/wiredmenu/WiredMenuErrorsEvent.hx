package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.*;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredMenuErrorsParser;
     final class WiredMenuErrorsEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction) { super(callback, WiredMenuErrorsParser); }
        public function getParser():WiredMenuErrorsParser { return Std.downcast(_parser , WiredMenuErrorsParser); }
    }

