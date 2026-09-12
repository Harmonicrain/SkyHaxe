package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.*;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredMenuInspectionParser;
     final class WiredMenuInspectionEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction) { super(callback, WiredMenuInspectionParser); }
        public function getParser():WiredMenuInspectionParser { return Std.downcast(_parser , WiredMenuInspectionParser); }
    }

