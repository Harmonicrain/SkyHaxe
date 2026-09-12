package com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredmenu
;
    import com.sulake.core.communication.messages.*;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredmenu.WiredMenuPermissionsParser;
     final class WiredMenuPermissionsEvent extends MessageEvent implements IMessageEvent
    {
        public function new(callback:ASFunction) { super(callback, WiredMenuPermissionsParser); }
        public function getParser():WiredMenuPermissionsParser { return Std.downcast(_parser , WiredMenuPermissionsParser); }
    }

